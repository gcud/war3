//获取键值对
function GetKeyValueData(form) {
    let Data = {};
    form.find("*[name]").each(function () {
        let Type=$(this).attr("type");
        let SetValue=true;
        switch (Type) {
            case "checkbox":
            case "radio":
                if(!$(this).prop("checked"))
                    SetValue=false;
                break;
        }
        if(SetValue)
            Data[$(this).attr("name")] = $(this).val();
    });
    return Data;
}

function CheckEnvironment() {
    if (location.protocol === "file:") {
        alert("本工具需要在服务器环境下运行来避免跨域问题");
        return false;
    }
    return true;
}

function GetConfig() {
    let Url = "config.json?" + Math.random();
    $.get(Url, function (Data) {
        for (let k in Data) {
            let Element=$("#Config [name=" + k + "]");
            switch (Element.attr("type")) {
                case "checkbox":
                case "radio":
                    for (let i=0;i<Element.length;i++)
                    {
                        if(Element[i].value===Data[k]){
                            Element[i].checked=true;
                        }
                    }
                    break;
                default:
                    Element.val(Data[k]);
            }
        }
    });
}

function SaveConfig() {
    let Config = GetKeyValueData($("#Config"));
    $.post("SaveConfig.php", Config, function () {
        alert("保存成功");
    });
}

function FunctionBind() {

}

function GetInfo() {
    let Url = "info.json?" + Math.random();
    $.get(Url, function (Data) {
        $("#LastCompile").text(Data.LastCompile);
    });
}

function Compile() {
    let Url = "Compile.php";
    $.post(Url, function () {
        alert("编译完成");
    });
}

function GetSummaryInfo() {
    let Target = $("#CompileResult");
    $("#LineNumber").text(Target.val().split(/\r*\n/).length);
    $("#CharacterNumber").text(Target.prop("textLength"));
}

function GetCompileContent() {
    let Url = "CompileResult.txt?" + Math.random();
    $.get(Url, function (Data) {
        $("#CompileResult").text(Data);
        GetSummaryInfo();
    });
}

function CopyCompileContent() {
    $("#CompileResult").select();
    document.execCommand("copy");
    alert("已复制");
}

function Init() {
    CheckEnvironment();
    FunctionBind();
    GetConfig();
    GetInfo();
    GetCompileContent();
}

Init();