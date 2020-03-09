SkillList = {
    List: {
        Skill1: {Level: 0},
        Skill2: {Level: 0},
        Skill3: {Level: 0},
        Final: {Level: 0},
        AttributeAdd: {Level: 0},
    },
    GetNew: function (Level, Priority) {
        let List = [];
        for (let i in this.List) {
            let Item = this.List[i];
            let JumpValue = 2;
            let MaxLevel = 9;
            let MinLevel = 0;
            if (i === "Final") {
                JumpValue = 6;
                MaxLevel = 3;
                MinLevel = 6;
            }
            if (i === "AttributeAdd") {
                MaxLevel = 30;
            }
            if (Item.Level < MaxLevel && Level >= MinLevel && Level + 1 >= (Item.Level + 1) * JumpValue) {
                List.push(i);
            }
        }
        for (let i = 0; i < Priority.length; i++) {
            if (List.indexOf(Priority[i]) > -1) {
                this.List[Priority[i]].Level++;
                return Priority[i];
            }
        }
    },
    ResetLevel: function () {
        for (let i in this.List) {
            this.List[i].Level = 0;
        }
    }
};

function Up(Element) {
    let Self = $(Element).parent().parent();
    let Prev = Self.prev();
    if (Prev.attr("data-type") !== "head") {
        Prev.before(Self);
    }
}

function Down(Element) {
    let Self = $(Element).parent().parent();
    let Prev = Self.next();
    if (Prev.length > 0) {
        Prev.after(Self);
    }
}

function GetMode() {
    return $("[name=mode]:checked").val();
}

function GetOrder() {
    let Order = [];
    $("tr[data-id]").each(function () {
        Order.push($(this).attr("data-id"));
    });
    return Order;
}

function Generate() {
    if (GetMode() === "0") {
        SkillList.ResetLevel();
        let Order = GetOrder();
        let LuaString = "";
        let SkillOrder = "";
        for (let i = 1; i <= 60; i++) {
            let Skill = SkillList.GetNew(i, Order);
            let Element = $("[data-id=" + Skill + "]");
            LuaString += 'StringToInteger("' + Element.find("[name=code]").val() + '"),';
            SkillOrder += Element.find("[name=name]").val() + ",";
        }
        $("#Lua").val(LuaString);
        $("#SkillOrder").text(SkillOrder);
    } else {
        alert("目前仅支持交替模式");
    }
}

function CopyLua() {
    $("#Lua")[0].select();
    document.execCommand("copy");
}
function RenderHeroList() {
    let Html='';
    for (let i=0;i<HeroSkillList.length;i++){
        let Hero=HeroSkillList[i];
        Html+=`<option value="${Hero.Id}">${Hero.Name}</option>`;
    }
    $("#HeroList").html(Html);
}
function SelectHero(Id) {
    for (let i=0;i<HeroSkillList.length;i++){
        let Hero=HeroSkillList[i];
        if(Hero.Id===Id){
            let SkillList=Hero.SkillList;
            for (let j=0;j<3;j++){
                let Row= $("tr[data-id='Skill"+(j+1)+"']");
                Row.find("[name=name]").val(SkillList[j].Name);
                Row.find("[name=code]").val(SkillList[j].Id);
            }
            let Row= $("tr[data-id='Final']");
            Row.find("[name=name]").val(SkillList[3].Name);
            Row.find("[name=code]").val(SkillList[3].Id);
        }
    }
}
function Init() {
    RenderHeroList();
}
Init();