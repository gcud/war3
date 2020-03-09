<?php
//设置编译时间
function SetInfo($Key, $Value)
{
    $InfoFile = 'info.json';
    $Config = json_decode(file_get_contents($InfoFile));
    $Config->$Key = $Value;
    file_put_contents($InfoFile, json_encode($Config));
}

function GetConfig()
{
    $ConfigFile = 'config.json';
    return json_decode(file_get_contents($ConfigFile));
}

function ConfigAction(&$Content, &$Config)
{
    //去除空行,此项不可配置
    while (strpos($Content, PHP_EOL . PHP_EOL) !== false)
        $Content = str_replace(PHP_EOL . PHP_EOL, PHP_EOL, $Content);
    //行处理
    $ContentArray = explode(PHP_EOL, $Content);
    //去除注释
    if ($Config->remove_comment) {
        $IsMultiLineComment = false;
    }
    foreach ($ContentArray as $Key => $Line) {
        //去除左侧缩进,此项不可配置
        $Line=ltrim($Line);
        //去除注释
        if ($Config->remove_comment) {
            $FourCharacter = substr($Line, 0, 4);
            $EndTwoCharacter = substr($Line, -2);
            //当前是多行注释开始标志,多行注释状态,多行注释结束标志,单行注释标志都要删除
            if ($FourCharacter === '--[[' || $IsMultiLineComment || $EndTwoCharacter === ']]' || substr($FourCharacter, 0, 2) === '--') {
                unset($ContentArray[$Key]);
            }
            else{
                $ContentArray[$Key]=$Line;
            }
            if ($FourCharacter === '--[[')
                $IsMultiLineComment = true;
            if ($EndTwoCharacter === ']]')
                $IsMultiLineComment = false;
        }
        else{
            $ContentArray[$Key]=$Line;
        }
    }
    $Content = implode(PHP_EOL, $ContentArray);
}
function DefaultAction(&$Content){
    //转换换行符
    $Content = str_replace("\r\n", PHP_EOL, $Content);
}

function Compile()
{
    $Config = GetConfig();
    $RootPath = $Config->root_path;
    $Content = '';
    GetContent($RootPath, $Content);
    DefaultAction($Content);
    ConfigAction($Content, $Config);
    $CompileResultFile = 'CompileResult.txt';
    file_put_contents($CompileResultFile, $Content);
}

function GetContent($Path, &$Content)
{
    foreach (new FilesystemIterator($Path) as $Item) {
        if ($Item->isDir()) {
            GetContent($Item->getPathname(), $Content);
        } elseif ($Item->getExtension() === 'lua') {
            $Content .= file_get_contents($Item->getPathname()) . PHP_EOL;
        }
    }
}

function Start()
{
    $Time = date('Y-m-d H:i:s');
    SetInfo('LastCompile', $Time);
    Compile();
}

Start();