/*
var GLB_MENU={
	// 대메뉴	-------------------------------------------------------------------------------------------------------
	menuinfo_ : [
		{menucd : '0101', menunm : '입고'		, menucss : 'navi_menu1', menuurl : '#'},
		{menucd : '0102', menunm : '출고'		, menucss : 'navi_menu2', menuurl : '#'},
		{menucd : '0103', menunm : '재고'		, menucss : 'navi_menu3', menuurl : '#'},
		{menucd : '0104', menunm : '수불'		, menucss : 'navi_menu4', menuurl : '#'},
		{menucd : '0106', menunm : '발주'		, menucss : 'navi_menu5', menuurl : '#'},
		{menucd : '0201', menunm : '마스터'		, menucss : 'navi_menu6', menuurl : '#'},
		{menucd : '0000', menunm : '열린메뉴'	, menucss : 'navi_menu6', menuurl : '#'},
		{menucd : '9999', menunm : 'Proto Type'	, menucss : 'navi_menu6', menuurl : '#'},

		{menucd : '0301', menunm : '설정'		, menucss : 'navi_menu7', menuurl : '#'}
	],


	// 중메뉴	-------------------------------------------------------------------------------------------------------
	menuinfo_0101 : [	// 입고
		{menucd : '010101', menunm : '입고대기'		, menucss : 'urlmn', menuurl : '/wms/service/ibd/ibdPreList.do'},
		{menucd : '010102', menunm : '입고실행'		, menucss : 'urlmn', menuurl : '/wms/service/ibd/ibdActList.do'},
		{menucd : '010103', menunm : '검수작업'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '010104', menunm : '적재작업'		, menucss : 'midmn', menuurl : '#'}
	],
	menuinfo_0102 : [	// 출고
		{menucd : '010201', menunm : '출고대기'		, menucss : 'urlmn', menuurl : '/wms/service/obd/obdPreList.do'},
		{menucd : '010202', menunm : '출고실행'		, menucss : 'urlmn', menuurl : '/wms/service/obd/obdActList.do'},
		{menucd : '010203', menunm : '피킹작업'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '010204', menunm : '출고검수작업'	, menucss : 'midmn', menuurl : '#'},
		{menucd : '010205', menunm : '출고전표'		, menucss : 'urlmn', menuurl : '/wms/service/obd/obdSlpList.do'},
		{menucd : '010206', menunm : '미출관리'		, menucss : 'urlmn', menuurl : '/wms/service/obd/obdDrpList.do'}
	],
	menuinfo_0103 : [	// 재고
		{menucd : '010301', menunm : '재고현황'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '010302', menunm : '이동작업'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '010303', menunm : '보충작업'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '010304', menunm : '가공작업'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '010305', menunm : '실사작업'		, menucss : 'midmn', menuurl : '#'}
	],
	menuinfo_0104 : [	// 수불
		{menucd : '010401', menunm : '수불현황'		, menucss : 'urlmn', menuurl : '/wms/service/ioh/iohNowList.do'},
		{menucd : '010402', menunm : '수불내역'		, menucss : 'urlmn', menuurl : '/wms/service/ioh/iohSubList.do'}
	],
	menuinfo_0105 : [	// 정산 (보류)
		{menucd : '010501', menunm : '정산현황'		, menucss : 'midmn', menuurl : '#'}
	],
	menuinfo_0106 : [	// 발주
		{menucd : '010601', menunm : '발주현황'		, menucss : 'urlmn', menuurl : '/wms/service/ord/ordNowList.do'}
	],
	menuinfo_0201 : [	// 마스터
		{menucd : '020101', menunm : '상품관리'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '020102', menunm : '구역관리'		, menucss : 'urlmn', menuurl : '/wms/master/area/areaMngList.do'},
		{menucd : '020103', menunm : '조직관리'		, menucss : 'urlmn', menuurl : '/wms/master/orgn/orgnMngList.do'}
	],
	menuinfo_0301 : [	// 설정
		{menucd : '030101', menunm : '사용자관리'	, menucss : 'urlmn', menuurl : '/wms/manage/user/userMngList.do'},
		{menucd : '030102', menunm : '도구관리'		, menucss : 'midmn', menuurl : '#'},
		{menucd : '030103', menunm : '메뉴관리'		, menucss : 'urlmn', menuurl : '/wms/config/menu/menuMngList.do'},
		{menucd : '030104', menunm : '코드관리'		, menucss : 'urlmn', menuurl : '/wms/config/code/codeMngList.do'},
		{menucd : '030105', menunm : '규칙관리'		, menucss : 'midmn', menuurl : '/wms/config/rule/ruleMngList.do'}
	],
	menuinfo_9999 : [	// 프로토타입
		{menucd : '999901', menunm : '일반 그리드 타입'	, menucss : 'urlmn', menuurl : '/wms/proto/grid_data_v2.do'},
		{menucd : '999902', menunm : '중첩그리드#1'		, menucss : 'urlmn', menuurl : '/wms/proto/grid_nest.do'},
		{menucd : '999903', menunm : '중첩그리드#2'		, menucss : 'urlmn', menuurl : '/wms/proto/grid_nestgrid.do'},
		{menucd : '999903', menunm : '마스터-디테일#1'	, menucss : 'urlmn', menuurl : '/wms/proto/ms_tree.do'},
		{menucd : '999903', menunm : '마스터-디테일#2'	, menucss : 'urlmn', menuurl : '/wms/proto/ms-grid.do'},
		{menucd : '999903', menunm : '리포팅1'			, menucss : 'urlmn', menuurl : '/wms/proto/rpt1.do'},
		{menucd : '999903', menunm : '리포팅2'			, menucss : 'urlmn', menuurl : '/wms/proto/rpt2.do'},
		{menucd : '999903', menunm : '리포팅3'			, menucss : 'urlmn', menuurl : '/wms/proto/rpt3.do'},
		{menucd : '999903', menunm : '리포팅4'			, menucss : 'urlmn', menuurl : '/wms/proto/rpt4.do'},
		{menucd : '999903', menunm : '컨포넌트모음'		, menucss : 'urlmn', menuurl : '/wms/proto/cmncmpt.do'}
	],
	menuinfo_0000 : [	// 열린메뉴
	],


	// 소메뉴	-------------------------------------------------------------------------------------------------------
	menuinfo_010103 : [	// 입고 > 검수작업
		{menucd : '01010301', menunm : '검수대기'		, menucss : 'urlmn', menuurl : '/wms/service/ibd/chkPreList.do'},
		{menucd : '01010302', menunm : '검수실행'		, menucss : 'urlmn', menuurl : '/wms/service/ibd/chkActList.do'}
	],
	menuinfo_010104 : [	// 입고 > 적재작업
		{menucd : '01010401', menunm : '적재대기'		, menucss : 'urlmn', menuurl : '/wms/service/ibd/putPreList.do'},
		{menucd : '01010402', menunm : '적재실행'		, menucss : 'urlmn', menuurl : '/wms/service/ibd/putActList.do'}
	],

	menuinfo_010203 : [	// 출고 > 피킹작업
		{menucd : '01020301', menunm : '피킹대기'		, menucss : 'urlmn', menuurl : '/wms/service/obd/picPreList.do'},
		{menucd : '01020302', menunm : '피킹실행'		, menucss : 'urlmn', menuurl : '/wms/service/obd/picActList.do'}
	],
	menuinfo_010204 : [	// 출고 > 출고검수
		{menucd : '01020401', menunm : '검수대기'		, menucss : 'urlmn', menuurl : '/wms/service/obd/ispPreList.do'},
		{menucd : '01020402', menunm : '검수실행'		, menucss : 'urlmn', menuurl : '/wms/service/obd/ispActList.do'}
	],

	menuinfo_010301 : [	// 재고 > 재고현황
		{menucd : '01030101', menunm : '상품별'		, menucss : 'urlmn', menuurl : '/wms/service/stk/stkPrdList.do'},
		{menucd : '01030102', menunm : 'LOC별'			, menucss : 'urlmn', menuurl : '/wms/service/stk/stkLocList.do'}
	],
	menuinfo_010302 : [	// 재고 > 이동작업
		{menucd : '01030201', menunm : '이동대기'		, menucss : 'urlmn', menuurl : '/wms/service/stk/movPreList.do'},
		{menucd : '01030202', menunm : '이동실행'		, menucss : 'urlmn', menuurl : '/wms/service/stk/movActList.do'}
	],
	menuinfo_010303 : [	// 재고 > 보충작업
		{menucd : '01030301', menunm : '보충대기'		, menucss : 'urlmn', menuurl : '/wms/service/stk/supPreList.do'},
		{menucd : '01030302', menunm : '보충실행'		, menucss : 'urlmn', menuurl : '/wms/service/stk/supActList.do'}
	],
	menuinfo_010304 : [	// 재고 > 가공작업
		{menucd : '01030401', menunm : '가공대기'		, menucss : 'urlmn', menuurl : '/wms/service/stk/rfmPreList.do'},
		{menucd : '01030402', menunm : '가공실행'		, menucss : 'urlmn', menuurl : '/wms/service/stk/rfmActList.do'}
	],
	menuinfo_010305 : [	// 재고 > 실사작업
		{menucd : '01030501', menunm : '실사대기'		, menucss : 'urlmn', menuurl : '/wms/service/stk/pckPreList.do'},
		{menucd : '01030502', menunm : '실사실행'		, menucss : 'urlmn', menuurl : '/wms/service/stk/pckActList.do'}
	],

	menuinfo_020101 : [	// 마스터 > 상품관리
		{menucd : '02010101', menunm : '상품그룹'		, menucss : 'urlmn', menuurl : '/wms/master/prod/prodGrpList.do'},
		{menucd : '02010102', menunm : '상품관리'		, menucss : 'urlmn', menuurl : '/wms/master/prod/prodMngList.do'}
	],
	menuinfo_030102 : [	// 설정 > 도구관리
		{menucd : '03010201', menunm : '라벨관리'		, menucss : 'urlmn', menuurl : '/wms/manage/tool/tlblMngList.do'},
		{menucd : '03010202', menunm : '배치실행'		, menucss : 'urlmn', menuurl : '/wms/manage/tool/tbatMngList.do'}
	],

};
*/


var MenuCtrl = {
	doAction : function (pid) {
		var pobj = $("#"+pid);
		var menunm = pobj.attr("name");
		var menuid = pobj.attr("id");
		var objlbl = pobj.next("label");
		var objsub = $(".left_2depth");
		
//		alert(pid);

		if (menunm == "topmenu") {
			// 열린 서브메뉴 닫기
			$("input[name='topmenu']").each(function() { $(this).prop("checked", $(this).attr("id") == menuid? true : false); });

			if (objsub.hasClass("on") == true) MenuCtrl.hideMidMenu();

			// 대메뉴 on 스타일 초기화 및 신규 등록
			$("#left-area li label.on").each(function() { $(this).removeClass("on"); });
			objlbl.addClass("on");

			MenuCtrl.initMidMenu();
			MenuCtrl.showBtmMenu();
			MenuCtrl.openMidMenu();
		}
		else if (menunm == "midmenu") {
			(objlbl.hasClass("on") == true)? MenuCtrl.hideBtmMenu() : MenuCtrl.openBtmMenu();
		}
		else if (menunm == "urlmenu" || menunm == "openmenu") {
			var urlmenu = $("input[name='urlmenu']:checked").val();
			var arrmenu = menuid.split("_");
			var pmenunm = "";
			var arrpath = [];

			$("#currmenuid").val("menu_"+arrmenu[1]);	// 현재링크 경로
			$("label.active").each(function() { $(this).removeClass("active"); });
			if (arrmenu[1].length >= 4) { $("#label_"+arrmenu[1].substr(0,4)).addClass("active"); pmenunm = $("#label_"+arrmenu[1].substr(0,4)).text(); }
			if (arrmenu[1].length >= 6) { $("#label_"+arrmenu[1].substr(0,6)).addClass("active"); pmenunm = $("#label_"+arrmenu[1].substr(0,6)).text(); arrpath.push(pmenunm); }
			if (arrmenu[1].length == 8) { $("#label_"+arrmenu[1].substr(0,8)).addClass("active"); pmenunm = $("#label_"+arrmenu[1].substr(0,8)).text(); arrpath.push(pmenunm); }

			MenuCtrl.hideMidMenu();
//			MenuCtrl.goUrl(arrmenu[1], arrpath.join(" &gt; "), urlmenu);
			MenuCtrl.goUrl(arrmenu[1], pmenunm, urlmenu);
		}

	},
	initTopMenu : function () {
		var strTopMenu = "";
		var idx = -1;

		$("#left_usernm").html(GLB_USER.usernm);

		$.each(eval("GLB_MENU.menuinfo_"), function (index, entry) {
			var tmcd = entry["menucd"];
			var tmnm = entry["menunm"];
			var mcss = entry["menucss"];
			var murl = entry["menuurl"];

			var tmid = "menu_"+tmcd;
			var testidx = $("#currmenuid").val().indexOf(tmid);

			mcss += ($("#currmenuid").val() != '' && $("#currmenuid").val().indexOf(tmid) >= 0)? " active" : "";

			var lcss = (tmcd == "0301") ? " class='setup'" : ""; // 설정메뉴
			var levt = (tmcd == "0000") ? " onmouseover='MenuCtrl.doAction(\""+tmid+"\")'" : ""; // 설정메뉴

			strTopMenu += "<li" + lcss + "><input type='radio' class='menunode' id='menu_" + tmcd + "' name='topmenu' value='" + tmcd + "' onclick='MenuCtrl.doAction(this.id)' />"
							+ "<label for='menu_" + tmcd + "' class='" + mcss + "' id='label_" + tmcd + "'" + levt +">" + tmnm + "</label></li>\n";
		});

		$("#topmenulist").html(strTopMenu);

	},
	initMidMenu : function () {
		var strMidMenu = "";
		var idx = -1;
		var topmenu = $("input[name='topmenu']:checked").val();

		if (topmenu != "") {
			$("#midmenunm").html($("#label_" + topmenu).text());

			$.each(eval("GLB_MENU.menuinfo_" + topmenu), function (index, entry) {
				var mmcd = entry["menucd"];
				var mmnm = entry["menunm"];
				var mcss = entry["menucss"];
				var murl = entry["menuurl"];

				var mmid = "menu_"+mmcd;
				mcss += ($("#currmenuid").val() != '' && $("#currmenuid").val().indexOf(mmid) >= 0)? " active" : "";

				if (topmenu == '0000') {	// 열린메뉴
					strMidMenu += "<li><input type='radio' class='menunode' id='opnmenu_" + mmcd + "' name='openmenu' value='" + mmcd + "' onclick='MenuCtrl.doAction(this.id)' />"
								+ "<label for='opnmenu_" + mmcd + "' class='" + mcss + "' id='opnlabel_" + mmcd + "'>" + mmnm + "<span class='delmenu' onclick=\"PanelCtrl.removePanel(event, '"+mmcd+"')\"><img src='/images/m2_close.png' class='m2_close'></span></label></li>\n";

				}
				else {

					if (murl != "#") {	// 링크 존재함 - 최종 노드
						strMidMenu += "<li><input type='radio' class='menunode' id='menu_" + mmcd + "' name='urlmenu' value='" + murl + "' onclick='MenuCtrl.doAction(this.id)' />"
									+ "<label for='menu_" + mmcd + "' class='" + mcss + "' id='label_" + mmcd + "'>" + mmnm + "</label></li>\n";

					}
					else {
						strMidMenu += "<li><input type='radio' class='menunode' id='menu_" + mmcd + "' name='midmenu' value='" + mmcd + "' onclick='MenuCtrl.doAction(this.id)' />"
									+ "<label for='menu_" + mmcd + "' class='sub " + mcss + "' id='label_" + mmcd + "'>" + mmnm + "</label>\n"
									+ "<div class='3depth'>";

						$.each(eval("GLB_MENU.menuinfo_" + mmcd), function (index, entry) {
							var bmcd = entry["menucd"];
							var bmnm = entry["menunm"];
							var bcss = entry["menucss"];
							var burl = entry["menuurl"];

							var bmid = "menu_"+bmcd;
							bcss += ($("#currmenuid").val() != '' && $("#currmenuid").val().indexOf(bmid) >= 0)? " active" : "";

							strMidMenu += "<p><input type='radio' class='menunode' id='menu_" + bmcd + "' name='urlmenu' value='" + burl + "' onclick='MenuCtrl.doAction(this.id)' />"
											+ "<label for='menu_" + bmcd + "' class='" + bcss + "' id='label_" + bmcd + "'>" + bmnm + "</label></p>\n";
						});
						strMidMenu += "</div></li>";
					}
				}
			});
		}
		$("#midmenulist").empty().html(strMidMenu);

	},
	openMidMenu : function () {
		var objsub = $(".left_2depth");
		objsub.animate({ left : '54px' }, 200);
		objsub.addClass("on");
	},
	hideMidMenu : function () {
		var objsub = $(".left_2depth");
		objsub.animate({ left : '-200px' }, 200);
		objsub.removeClass("on");
	},
	showBtmMenu : function () {
		var midmenu = $("#currmenuid").val();
		if (midmenu != "") {
			var arrmenu = midmenu.split("_");

			var objlvl = $("#label_"+arrmenu[1].substr(0,6));
			if (typeof(objlvl) != "undefined") {
				$(".3depth").slideUp("slow");
				if (objlvl.hasClass("active") != true) objlvl.addClass("on");
				objlvl.next("div").slideDown(300);
			}
		}
	},
	openBtmMenu : function () {
		var midmenu = $("input[name='midmenu']:checked").val();
		if (midmenu != "") {
			var objlvl = $("#label_"+midmenu);
			if (typeof(objlvl) != "undefined") {
				$(".left_2depth li label.on").each(function() { $(this).removeClass("on"); });
				$(".3depth").slideUp("slow");
				if (objlvl.hasClass("active") != true) objlvl.addClass("on");
				objlvl.next("div").slideDown(300);
			}
		}
	},
	hideBtmMenu : function () {
		var midmenu = $("input[name='midmenu']:checked").val();
		if (midmenu != "") {
			var objlvl = $("#label_"+midmenu);
			if (typeof(objlvl) != "undefined") {
				$(".3depth").slideUp("slow");
				objlvl.removeClass("on");
			}
		}
	},
	goUrl : function (pmenuid, pmenunm, purl) {
		PanelCtrl.openPanel(pmenuid, pmenunm, purl);
	},
};

