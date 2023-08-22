

//---------------------------------------------------------------------------------------
//	AuthViewCtrl
//
//		설  명	: 권한공통 함수 Controller
//
//		사용법	:
//		$(document).ready(function() {
//			var _authCtrl = AuthViewCtrl;
//
//			// 버튼노드 배열형 ([노드배열], [권한문자열])
//			_authCtrl.set(["#kgrid_tb_selview", "#kgrid_tb_select"], "SA,TI,TO,UI,UO");
//
//			// 버튼노드 문자열형 ([노드문자열], [권한문자열])
//			_authCtrl.set("#kgrid_tb_selview2, #kgrid_tb_save2", "SA,TI");
//		});
//
//---------------------------------------------------------------------------------------

var AuthViewCtrl = (function() {

//	var clickact_list = [];
//	var viewnode_list = [];
//	var authrole_list = [];
	var authuser_list = [];

	// 전역 사용자 권한 정보 로딩
	function _init() {
		if (authuser_list.length == 0) {  
			$.extend(true, authuser_list, GLB_USER.roles.replace("ROLE_PCD_", "").split(","));
		}
	}


	//---------------------------------------------------------
	//	권한 유무 체크
	//---------------------------------------------------------
	function _existRole(proles) {
		var list = proles.split(",");
		var isfind = false;

		$.each(list, function (idx, val) {
			var result = $.inArray(val, authuser_list);
			if (result > -1) isfind = true;
		});
		return isfind;
	};

	//---------------------------------------------------------
	//	HTML NODE 숨김처리
	//---------------------------------------------------------
	function _hideNode(pnode) {
		if (typeof(pnode) !== "undefined") {
			pnode.hide();
		}
	};


	//---------------------------------------------------------
	//	권한 버튼 전시 함수
	//---------------------------------------------------------
	function _setClickAuth(pnode, pauth) {
		var onode;

		switch (typeof pnode) {
			case "object" :
				if ($.isArray(pnode) == true) {	// 배열형 노드
					onode = $(pnode.join(","));
					$.each(onode, function (index, entry) {
						if (_existRole(pauth) == false) _hideNode($(this));
					});
				}
				else {	// Object형 노드
					onode = pnode;
					$.each(onode, function (index, entry) {
						if (_existRole(pauth) == false) _hideNode($(this));
					});
				}

				break;

			case "string" :	// 문자열형 노드
				onode = $(pnode);
				$.each(onode, function (index, entry) {
					if (_existRole(pauth) == false) _hideNode($(this));
				});

				break;
		}
	};

	//---------------------------------------------------------
	// 인터페이스 함수 반환
	//---------------------------------------------------------
	return {
		set	:	function(pnode, pauth) {
					_init();
					_setClickAuth(pnode, pauth);
				}

	};
})();

