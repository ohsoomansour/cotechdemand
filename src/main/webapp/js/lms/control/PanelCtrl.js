
var PanelCtrl = {
	openPanel : function (pmenuid, pmenunm, purl) {
		var panelList = GLB_MENU.menuinfo_0000;
		var openidx = -1;

		// 기존에 존재하는지 체크 후에 신규 생성 (존재하면 해당 패널 오픈)
		$.each(panelList, function (index, entry) {
			if (pmenuid == entry["menucd"]) openidx = index;
		});

		(openidx > -1)? PanelCtrl.selectPanel(pmenuid, openidx) : PanelCtrl.appendPanel(pmenuid, pmenunm, purl);

	},
	appendPanel : function (pmenuid, pmenunm, purl) {
		var panelList = GLB_MENU.menuinfo_0000;
		var idx = panelList.length + 1;

		var strPanel = "<div id='mfpanel_"+pmenuid+"' class='mf_panel' style='z-index:"+idx+";'>"
					+ "<iframe id='mfframe_"+pmenuid+"' class='mf_frame' frameborder='0' src='"+purl+"'></iframe>"
					+ "</div>";
		$("#mf_content").append(strPanel);

		var panelItem = {'menucd' : pmenuid, 'menunm' : pmenunm, 'menucss' : 'openmenu', 'menuurl' : purl };
		panelList.unshift(panelItem);

		GLB_MENU.menuinfo_0000 = panelList;
	},
	selectPanel : function (pmenuid, pidx) {
		var panelList = GLB_MENU.menuinfo_0000;
		var len = panelList.length;

		var panelItem = panelList.splice(pidx, 1);
		panelList.unshift(panelItem[0]);

		GLB_MENU.menuinfo_0000 = panelList;

		$.each(panelList, function (index, entry) {
			$("#mfpanel_"+entry["menucd"]).css("z-index", len - index);
		});
	},
	removePanel : function (ev, pmenuid) {
		ev.preventDefault();
		MenuCtrl.hideMidMenu();

		var panelList = GLB_MENU.menuinfo_0000;
		var openidx = -1;
		var menunm = "";
		var len = panelList.length - 1;

		// 기존에 존재하는지 체크 후에 신규 생성 (존재하면 해당 패널 오픈)
		$.each(panelList, function (index, entry) {
			if (pmenuid == entry["menucd"]) {
				openidx = index;
				menunm = entry["menunm"];
			}
		});
		
		if (openidx > -1 && confirm("[ "+menunm+" ]" + " 작업창을 닫으시겠습니까?")) {
			var panelItem = panelList.splice(openidx, 1);
			$("#mfpanel_"+pmenuid).remove();
	
			GLB_MENU.menuinfo_0000 = panelList;
	
			$.each(panelList, function (index, entry) {
				$("#mfpanel_"+entry["menucd"]).css("z-index", len - index);
			});
		}

	},
};

