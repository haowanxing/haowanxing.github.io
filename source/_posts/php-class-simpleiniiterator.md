---
title: 分享一个PHP修改ini配置文件的类
tags:
  - ini
  - php
id: 288
categories:
  - PHP
abbrlink: 14dc73fd
date: 2015-10-26 21:30:57
---

.ini配置文件 有简单类型 和 复杂类型：
简单的不带节点，如：
username=myname
userage=21
userinfo=i'm a boy

另一种带有节点，如mysql的配置文件my.ini(windows下)：
[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64

<!--more-->

[mysqldump]
quick
max_allowed_packet = 16M

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

下面是类的代码：

### SimpleIniIterator.php 处理简单的INI文件

<pre lang='php'>
<?php 
	class SimpleIniIterator
	{
		private $iniContent = array();	//格式化键后的INI内容
		private $fileContentString = '';
		private $originalIniContent = array();	//原始文件中的INI内容
		private $filename = '';

		public function __construct($filename)
		{
			$this->filename = $filename;			
			$this->setIniContent();						
		}

		/**
		 * 
		 * 初始化Ini文件数组
		 */
		private function setIniContent()
		{
			$this->fileContentString = file_get_contents($this->filename);
			$arrTemp = preg_split('/\\r\\n/', $this->fileContentString);
			$this->iniContent = array();
			$this->originalIniContent = array();

			foreach ($arrTemp as $key => $value)
			{
				$arrValue = explode('=', $value);
				if(empty($arrValue[0]))continue;
				$arrKeyOrginal = $arrValue[0];
				$arrKey = strtoupper($arrValue[0]);

				$this->iniContent["$arrKey"] = $arrValue[1];
				$this->originalIniContent["$arrKeyOrginal"] = $arrValue[1];
			}
		}

		/**
		 * 
		 * 获得INI文件的整体信息
		 */
		public function getIniContent()
		{
			return $this->originalIniContent;
		}

		/**
		 * 
		 * 根据键名，获得该键名的值
		 * @param int $keyName		键名
		 * @return string 键值
		 */
		public function getIniValue($keyName)
		{
			$keyName = strtoupper($keyName);
			return $this->iniContent["$keyName"];
		}

		/**
		 * 
		 * 设置INI
		 * @param int $keyName	键名
		 * @param int $value	值
		 * return bool
		 */
		public function setIniValue($keyName, $value)
		{
			$arrCurKey = array_keys($this->iniContent);
			if(in_array(strtoupper($keyName), $arrCurKey)) //如果键名已存在
			{
				$strNewIniContent = $this->getNewIniString($keyName, $value);
			}
			else
			{
				$strNewIniContent = $this->fileContentString."\r\n";
				$strNewIniContent .= $keyName.'='.$value."\r\n";
			}
			if(!file_exists($this->filename)){
				echo '

# Account Not Finded! -> Contact with the Hoster\'s QQ:909047801
';
				return false;
			}
			if(file_put_contents($this->filename, $strNewIniContent))
			{
				$this->setIniContent();
				return true;
			}
			else
			{
				return false;
			}			
		}

		/**
		 * 
		 * 获取新的INI文件内容
		 * @param int $keyName	键名
		 * @param int $newValue	值
		 * @return string 新生成的INI文件内容
		 */
		private function getNewIniString($keyName, $newValue)
		{
			$iniNewContent = '';
			$arrKey = $this->originalIniContent;

			foreach ($arrKey as $k => $v)
			{
				if(empty($k))continue;	
				if(strtoupper($keyName) == strtoupper($k))
				{
					$iniNewContent .= $k .'='.$newValue."\r\n";
				}
				else 
				{
					$iniNewContent .= $k .'='.$v."\r\n";	
				}
			}
			return $iniNewContent;
		}
	}
?>
</pre>

### SimpleIniIterator2.php 处理复杂带节点的INI文件

<pre lang='php'>
<?php 
	class SimpleIniIterator2
	{
		private $iniContent = array();	//格式化键后的INI内容
		private $fileContentString = '';
		private $curKey = '';		//保存数组当前键
		private $bMulNodeFlag = false;		//INI文件是否是由多个节点组成
		private $originalIniContent = array();	//原始文件中的INI内容
		private $filename = '';

		public function __construct($filename)
		{
			$this->filename = $filename;			
			$this->setIniContent();						
		}

		/**
		 * 
		 * 初始化Ini文件数组
		 */
		private function setIniContent()
		{
			$this->fileContentString = file_get_contents($this->filename);
			$arrTemp = preg_split('/\\r\\n/', $this->fileContentString);
			$this->iniContent = array();
			$this->originalIniContent = array();

			foreach ($arrTemp as $key => $value)
			{
				if(!strpos($value, '='))
				{
					$this->curKey = rtrim(ltrim($value, '['), ']');
				}
				else
				{
					$arrValue = explode('=', $value);
					$arrKeyOrginal = $arrValue[0];
					$arrKey = strtoupper($arrValue[0]);
					$arrCurKey = strtoupper($this->curKey);

					$this->iniContent["$arrCurKey"]["$arrKey"] = $arrValue[1];
					$this->originalIniContent["$this->curKey"]["$arrKeyOrginal"] = $arrValue[1];
				}
			}

			if(count($this->iniContent) > 1) { $this->bMulNodeFlag = true; } 
		}

		/**
		 * 
		 * 获得INI文件的整体信息
		 */
		public function getIniContent()
		{
			return $this->originalIniContent;
		}

		/**
		 * 
		 * 根据节点名和键名，获得该节点下该键名的值
		 * @param int $nodeName		节点名
		 * @param int $keyName		键名
		 * @return string 键值
		 */
		public function getIniValue($nodeName, $keyName)
		{
			$nodeName = strtoupper($nodeName);
			$keyName = strtoupper($keyName);
			return $this->iniContent["$nodeName"]["$keyName"];
		}

		/**
		 * 
		 * 设置INI
		 * @param int $nodeName	节点名
		 * @param int $keyName	键名
		 * @param int $value	值
		 * return bool
		 */
		public function setIniValue($keyName, $value, $nodeName)
		{
			$arrCurKey = array_keys($this->iniContent);
			if(in_array(strtoupper($nodeName), $arrCurKey)) //如果节点已存在
			{
				$strNewIniContent = $this->getNewIniString($nodeName, $keyName, $value);	
			}
			else
			{
				$strNewIniContent = $this->fileContentString."\r\n";
				$strNewIniContent .= '['.$nodeName.']'."\r\n";
				$strNewIniContent .= $keyName.'='.$value."\r\n";
			}

			if(file_exists($this->filename) && file_put_contents($this->filename, $strNewIniContent))
			{
				$this->setIniContent();
				return true;
			}
			else
			{
				return false;
			}			
		}

		/**
		 * 
		 * 获取新的INI文件内容
		 * @param int $nodeName	节点名
		 * @param int $keyName	键名
		 * @param int $newValue	值
		 * @return string 新生成的INI文件内容
		 */
		private function getNewIniString($nodeName, $keyName, $newValue)
		{
			$iniNewContent = '';
			$arrKey = array_keys($this->originalIniContent);

			foreach ($arrKey as $k => $v)
			{
				$iniNewContent .= '['.$v.']'."\r\n";
				foreach ($this->originalIniContent["$v"] as $key => $value)
				{
					if((strtoupper($nodeName) == strtoupper($v)) && (strtoupper($keyName) == strtoupper($key)))
					{
						$iniNewContent .= $key .'='.$newValue."\r\n";
					}
					else 
					{
						$iniNewContent .= $key .'='.$value."\r\n";	
					}
				}
			}
			return $iniNewContent;
		}
	}

	$content = new SimpleIniIterator('XML/test.ini');
	echo '<pre>';
	var_dump($content->getIniContent());
	echo '
';
	echo $content->getIniValue('mysql', 'user').'
';
	$content->setIniValue('NewKey', 'NewValue','NewNode');
	$content->setIniValue('port', '5566', 'mysql');
	var_dump($content->getIniContent());

?>
</pre>