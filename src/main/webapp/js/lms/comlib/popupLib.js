/**
 * 사용자이름 클릭하면 구성원정보 팝업본기
 * @param userid
 */
function comlib_popupUser(userid) {
	var url = "http://portlet.skhynix.com/PS/portlets/etc/userinfo.jsp?str=" + userid;
	var cw =screen.availWidth;     //화면 넓이
	var ch =screen.availHeight;    //화면 높이
	var sw=620;    //띄울 창의 넓이
	var sh=760;    //띄울 창의 높이

	var ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
	var mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
	window.open(url,'popUserWin','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
}

/**
 * 사용자이름 클릭하면 구성원정보 팝업본기
 * @param userid
 */
function comlib_popupContent(url) {
	var cw =screen.availWidth;     //화면 넓이
	var ch =screen.availHeight;    //화면 높이
	var sw=cw;    //띄울 창의 넓이
	var sh=ch;    //띄울 창의 높이

	var ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
	var mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
	window.open(url,'popUserWin','width='+cw+',height='+ch+',top='+mt+',left='+ml+',resizable=yes,scrollbars=yes');
}