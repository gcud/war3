--[[
gcud函数库
如果你有什么问题可以与我联系,我的微信号是gcudzy,邮箱是gcudfun@163.com,如果是微信添加好友你需要注明你的来意
--]]
--此函数的调用必须在游戏开始后
function InitBaseConstant()
	InitBaseConstant=nil
	Base={
		Version="20200308",
		LeftX=GetCameraBoundMinX() - GetCameraMargin(CAMERA_MARGIN_LEFT),
		RightX=GetCameraBoundMaxX() + GetCameraMargin(CAMERA_MARGIN_RIGHT),
		DownY=GetCameraBoundMinY() - GetCameraMargin(CAMERA_MARGIN_BOTTOM),
		UpY=GetCameraBoundMaxY() + GetCameraMargin(CAMERA_MARGIN_TOP),
		MAP_AREA=nil,
		NEUTRAL_PASSIVE=Player(PLAYER_NEUTRAL_PASSIVE),
		NEUTRAL_AGGRESSIVE=Player(PLAYER_NEUTRAL_AGGRESSIVE),
		DEGTORAD=0.01745329251994329576
	}
	Base.MAP_AREA=Rect(Base.LeftX,Base.DownY,Base.RightX,Base.UpY)
end