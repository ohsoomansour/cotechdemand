<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	var subCheck = 0;
	var updateCheck = 0;
	$(document).ready(function(){
		var useAuth = ${use_auth};
		checkUseAuth(useAuth, [$('#btnMenuInsert')], [$('#btnMenuUpdate')], [$('#btnMenuDelete')]);
		
		//jstree 셋팅
		fncMenuTreeSetting();
		
		//메뉴 취소버튼 추가 2020/05/27 - 추정완
		$('#btnCancel').click(function() {
			location.reload();
		});
		//메뉴 등록버튼 추가 2020/05/08 - 추정완
		$('#btnMenuInsert').click(function() {
			$('#btnCancel').css('display', 'inline');
			$('#btnMenuUpdate').prop('disabled', true);
			$('#btnMenuDelete').prop('disabled', true);
			if(subCheck == 0) {
				subCheck = 1;
				$('.sub_table').fadeIn();
				$('#trURL').hide();
				$('#menuNm').val('');
				$("#menuPCD option:eq(0)").prop("selected", true);
				$('#menuNmEn').val('');
				$('#menuCmmt').val('');
				$('#menuURL').val('');
			}
			else{
				var selectNode = $("#menuTree").jstree('get_selected');
			    var nodeLevel = selectNode.attr('value');
			    //노드가 선택되었을때
			   	if(nodeLevel != undefined) {
			   		console.log(nodeLevel);
			   		if(nodeLevel <= 2) {
			   			var gubun = $('#menuPCD').val();
						if(gubun == 'MENU_P001' || gubun == 'MENU_P002' || gubun == 'MENU_P003') {
					   		if(!isBlank('메뉴명', '#menuNm'))
							if(!isBlank('메뉴명 영어', '#menuNmEn'))
							if(!isBlank('메뉴 설명', '#menuCmmt'))	
							if(!isBlank('URL', '#menuURL')){
						   		var mode = 'SI';
						   		var nodeId = selectNode.attr('id');
						   		var menuLevel = Number(nodeLevel) + 1;
						   		var menuPCD = $('#menuPCD').val();
						   		var menuTCD = $('#menuTCD').val();
								var menuNm = $('#menuNm').val();
								var menuNmEn = $('#menuNmEn').val();
								var menuCmmt = $('#menuCmmt').val();
								var menuURL = $('#menuURL').val();
								var menuUseYn = $('input[name="menuUseYn"]:checked').val();
								$.ajax({
									type : 'POST',
									url : '/admin/menuOption.do',
									data : {
										mode : mode,
										up_cd : nodeId,
										menu_lvl : menuLevel,
										menu_pcd : menuPCD,
										menu_tcd : menuTCD,
										menunm : menuNm,
										menunm_en : menuNmEn,
										menu_cmmt : menuCmmt,
										menu_url : menuURL,
										useyn : menuUseYn
									},
									dataType : 'json',
									traditional : true,
									success : function() {
										alert_popup('등록되었습니다.');
									},
									error : function(e) {
										alert_popup(e);
									},
									complete : function() {
										location.reload();
									}
								});
							}
						}
						else{
					   		if(!isBlank('메뉴명', '#menuNm'))
					   		if(!isBlank('메뉴 구분', '#menuPCD'))
							if(!isBlank('메뉴명 영어', '#menuNmEn'))
							if(!isBlank('메뉴 설명', '#menuCmmt')) {
						   		var mode = 'SI';
						   		var nodeId = selectNode.attr('id');
						   		var menuLevel = Number(nodeLevel) + 1;
						   		var menuPCD = $('#menuPCD').val();
						   		var menuTCD = $('#menuTCD').val();
								var menuNm = $('#menuNm').val();
								var menuNmEn = $('#menuNmEn').val();
								var menuCmmt = $('#menuCmmt').val();
								var menuURL = null;
								var menuUseYn = $('input[name="menuUseYn"]:checked').val();
								$.ajax({
									type : 'POST',
									url : '/admin/menuOption.do',
									data : {
										mode : mode,
										up_cd : nodeId,
										menu_lvl : menuLevel,
										menu_pcd : menuPCD,
										menu_tcd : menuTCD,
										menunm : menuNm,
										menunm_en : menuNmEn,
										menu_cmmt : menuCmmt,
										menu_url : menuURL,
										useyn : menuUseYn
									},
									dataType : 'json',
									traditional : true,
									success : function() {
										alert_popup('등록되었습니다.');
									},
									error : function(e) {
										alert_popup(e);
									},
									complete : function() {
										location.reload();
									}
								});
							}
						}
					}
			   		else if(nodeLevel == 3){
			   			alert_popup('Menu Detph는 3까지입니다.');
					}
			   	}
			    //노드가 선택이 안되었을때 -> 탑메뉴로 등록되게끔
			   	else{
			   		var menuConfirm = confirm('노드가 선택되어있지 않습니다. 탑메뉴로 등록하시겠습니까?');
			   		if(menuConfirm) {
						var gubun = $('#menuPCD').val();
						if(gubun == 'MENU_P001' || gubun == 'MENU_P002' || gubun == 'MENU_P003') {
							if(!isBlank('메뉴명', '#menuNm'))
							if(!isBlank('메뉴 구분', '#menuPCD'))
							if(!isBlank('메뉴명 영어', '#menuNmEn'))
							if(!isBlank('메뉴 설명', '#menuCmmt'))	
							if(!isBlank('URL', '#menuURL'))	{
								var mode = 'MI';
								var menuLevel = 1;
								var menuTCD = $('#menuTCD').val();
								var menuPCD = $('#menuPCD').val();
								var menuUPCD = '';
								var menuNm = $('#menuNm').val();
								var menuNmEn = $('#menuNmEn').val();
								var menuCmmt = $('#menuCmmt').val();
								var menuURL = $('#menuURL').val();
								var menuUseYn = $('input[name="menuUseYn"]:checked').val();
								if(menuTCD == 'A') {
									menuUPCD = 'ADMIN_MENU_TREE';
								}
								else if(menuTCD == 'H') {
									menuUPCD = 'HOMEPAGE_MENU_TREE';
								}
								$.ajax({
									type : 'POST',
									url : '/admin/menuOption.do',
									data : {
										mode : mode,
										up_cd : menuUPCD,
										menu_lvl : menuLevel,
										menu_pcd : menuPCD,
										menu_tcd : menuTCD,
										menunm : menuNm,
										menunm_en : menuNmEn,
										menu_cmmt : menuCmmt,
										menu_url : menuURL,
										useyn : menuUseYn
									},
									dataType : 'json',
									traditional : true,
									success : function() {
										alert_popup('등록되었습니다.');
									},
									error : function(e) {
										alert_popup(e);
									},
									complete : function() {
										location.reload();
									}
								});
							}
						}
						else{
							if(!isBlank('메뉴명', '#menuNm'))
							if(!isBlank('메뉴 구분', '#menuPCD'))
							if(!isBlank('메뉴명 영어', '#menuNmEn'))
							if(!isBlank('메뉴 설명', '#menuCmmt'))	{
								var mode = 'MI';
								var menuLevel = 1;
								var menuTCD = $('#menuTCD').val();
								var menuPCD = $('#menuPCD').val();
								var menuUPCD = '';
								var menuNm = $('#menuNm').val();
								var menuNmEn = $('#menuNmEn').val();
								var menuCmmt = $('#menuCmmt').val();
								var menuURL = null;
								var menuUseYn = $('input[name="menuUseYn"]:checked').val();
								if(menuTCD == 'A') {
									menuUPCD = 'ADMIN_MENU_TREE';
								}
								else if(menuTCD == 'H') {
									menuUPCD = 'HOMEPAGE_MENU_TREE';
								}
								$.ajax({
									type : 'POST',
									url : '/admin/menuOption.do',
									data : {
										mode : mode,
										up_cd : menuUPCD,
										menu_lvl : menuLevel,
										menu_pcd : menuPCD,
										menu_tcd : menuTCD,
										menunm : menuNm,
										menunm_en : menuNmEn,
										menu_cmmt : menuCmmt,
										menu_url : menuURL,
										useyn : menuUseYn
									},
									dataType : 'json',
									traditional : true,
									success : function() {
										alert_popup('등록되었습니다.');
									},
									error : function(e) {
										alert_popup(e);
									},
									complete : function() {
										location.reload();
									}
								});
							}
						}
			   		}
			   		else{
			   			alert_popup('취소했습니다.');
			   			location.reload();
			   		}
			   	}
			}
		});
		//메뉴 수정버튼 추가 2020/05/08 - 추정완
		$('#btnMenuUpdate').click(function() {
			var selectNode = $("#menuTree").jstree('get_selected').attr('id');
			if(selectNode != undefined) {
				$('#btnCancel').css('display', 'inline');
				$('#btnMenuInsert').prop('disabled', true);
				$('#btnMenuDelete').prop('disabled', true);
				if(updateCheck == 0) {
					$('.sub_table').fadeIn();
					updateCheck = 1;
				}
				else{
					var gubun = $('#menuPCD').val();
					if(gubun == 'MENU_P001' || gubun == 'MENU_P002' || gubun == 'MENU_P003') {
						if(!isBlank('메뉴명', '#menuNm'))
						if(!isBlank('메뉴 구분', '#menuPCD'))
						if(!isBlank('메뉴명 영어', '#menuNmEn'))
						if(!isBlank('메뉴 설명', '#menuCmmt'))	
						if(!isBlank('URL', '#menuURL'))	{
							var mode = 'U';
							var menuNm = $('#menuNm').val();
							var menuPCD = $('#menuPCD').val();
							var menuNmEn = $('#menuNmEn').val();
							var menuCmmt = $('#menuCmmt').val();
							var menuURL = $('#menuURL').val();
							var menuUseYn = $('input[name="menuUseYn"]:checked').val();
							var childList = [];
							$('#' + selectNode).children().find('li').each(function(index, item) {
								childList.push(item.id);
							});
							$.ajax({
								type : 'POST',
								url : '/admin/menuOption.do',
								data : {
									mode : mode,
									menucd : selectNode,
									menunm : menuNm,
									menu_pcd : menuPCD,
									menunm_en : menuNmEn,
									menu_cmmt : menuCmmt,
									menu_url : menuURL,
									menucdList : childList,
									useyn : menuUseYn
								},
								dataType : 'json',
								traditional : true,
								success : function() {
									alert_popup('수정되었습니다.');
								},
								error : function(e) {
									alert_popup(e);
								},
								complete : function() {
									location.reload();
								}
							});
						}
					}
					else{
						if(!isBlank('메뉴명', '#menuNm'))
						if(!isBlank('메뉴 구분', '#menuPCD'))
						if(!isBlank('메뉴명 영어', '#menuNmEn'))
						if(!isBlank('메뉴 설명', '#menuCmmt'))	{
							var mode = 'U';
							var menuNm = $('#menuNm').val();
							var menuPCD = $('#menuPCD').val();
							var menuNmEn = $('#menuNmEn').val();
							var menuCmmt = $('#menuCmmt').val();
							var menuURL = null;
							var menuUseYn = $('input[name="menuUseYn"]:checked').val();
							var childList = [];
							$('#' + selectNode).children().find('li').each(function(index, item) {
								childList.push(item.id);
							});
							$.ajax({
								type : 'POST',
								url : '/admin/menuOption.do',
								data : {
									mode : mode,
									menucd : selectNode,
									menunm : menuNm,
									menu_pcd : menuPCD,
									menunm_en : menuNmEn,
									menu_cmmt : menuCmmt,
									menu_url : menuURL,
									menucdList : childList,
									useyn : menuUseYn
								},
								dataType : 'json',
								traditional : true,
								success : function() {
									alert_popup('수정되었습니다.');
								},
								error : function(e) {
									alert_popup(e);
								},
								complete : function() {
									location.reload();
								}
							});
						}
					}
				}
			}
			else{
				alert_popup('선택된 노드가 없습니다.');
			}
		});
		//메뉴 삭제버튼 추가 2020/05/08 - 추정완
		$('#btnMenuDelete').click(function() {
			var menucdList = new Array();
			var selectNode = $("#menuTree").jstree('get_selected').attr('id');
			console.log(selectNode);
			menucdList.push(selectNode);
			$("#menuTree").jstree('get_selected').children().find('li').each(function(index, item){
				console.log(item);
				menucdList.push(item.id);
			});
			console.log(menucdList);
			if(selectNode != undefined) {
				if(confirm('삭제하시겠습니까?')) {
					var mode = 'D';
					var nodeId = selectNode;
					$.ajax({
						type : 'POST',
						url : '/admin/menuOption.do',
						data : {
							mode : mode,
							menucdList : menucdList
						},
						dataType : 'json',
						traditional : true,
						success : function() {
							alert_popup('삭제되었습니다.');
						},
						error : function(e) {
							alert_popup(e);
						},
						complete : function() {
							location.reload();
						}
					});
				}
				else{
					alert_popup('취소 되었습니다.');
				}
			}
			else{
				alert_popup('선택된 노드가 없습니다.');
			}
		});
		
	});
	// 메뉴 트리 셋팅 추가 2020/05/07 - 추정완
	function fncMenuTreeSetting() {
		subCheck = 0;
		updateCheck = 0;
		$('.sub_table').hide();
		$('#btnCancel').css('display', 'none');
		$('#btnMenuInsert').prop('disabled', false);
		$('#btnMenuUpdate').prop('disabled', false);
		$('#btnMenuDelete').prop('disabled', false);
		$('#menuNm').val('');
		$("#menuPCD option:eq(0)").prop("selected", true);
		$('#menuNmEn').val('');
		$('#menuCmmt').val('');
		$('#menuURL').val('');
		var menu_tcd = fncMenuObject();
		console.log(menu_tcd);
		$.ajax({
			type:'POST',
			url:'/admin/listTreemenu.do',
			data : {
				menu_tcd : menu_tcd
			},
			success:function(data) {
	
				var strMenuTree = data.strMenuTree;
				if(strMenuTree != undefined) {
					$('#menuTree').html(strMenuTree);
					$('#menuTree').jstree({
						"crrm" : {
				            "move" : {
				                "check_move" : function (data) {
				                	/* 
				                		jstree는 자동으로 부모가 자식노드로 이동 불가함
				                		단, 자식은 특정조건이 있지 않는 한 자유롭게 이동가능				                		
				                		이동가능 true 이동불가 false
				                	*/
				                	return true;
				                }
				            }
						},
						"dnd" : {
							 "drop_check" : function (data) {							 	
			                	return {
			                    	after : false,
			                    	before : false,
			                    	inside : true
			                	};
				        	}
						},
						'plugins' : ['themes', 'html_data', 'ui', 'crrm', 'dnd'],
					})
					.bind('loaded.jstree', function() {
						$('#menuTree').jstree('open_all');
					})
					.bind('select_node.jstree', function(e, data) {
						var node = data.rslt.obj[0];
						$.ajax({
							type:'POST',
							url:'/admin/menuGetInfo.do',
							data : {
								menucd : node.id
							},
							async: false,
							success : function(data) {
								console.log('등록창 여부 : ' + subCheck);
								console.log('수정창 등록창 여부 : ' + updateCheck);
								if(subCheck != 1) {
									var nodeInfo = data.menuInfo;
									$('#menuNm').val(nodeInfo.menunm);
									$('#menuNmEn').val(nodeInfo.menunm_en);
									$('#menuCmmt').val(nodeInfo.menu_cmmt);
									$('#menuURL').val(nodeInfo.menu_url);
									var radio = $("input[name='menuUseYn']");
									for(var i = 0; i < radio.length; i++) {
										if(radio[i].value == nodeInfo.useyn) {
											radio[i].checked = true;
										}
									}
									var selectBox = $('#menuPCD option');
									for(var i = 0; i < selectBox.length; i++) {
										if(selectBox[i].value == nodeInfo.menu_pcd) {
											selectBox[i].selected = true;
										}
									}
									
									var selectGubun = $('#menuPCD option:selected').val();
									if(selectGubun == 'MENU_P001' || selectGubun == 'MENU_P002' || selectGubun == 'MENU_P003') {
										$('#trURL').show();
									}
									else{
										$('#trURL').hide();
									}
								}
								if(subCheck == 1) {
									$('#menuNm').val(null);
									$('#menuNmEn').val(null);
									$('#menuCmmt').val(null);
									$('#menuURL').val(null);
									$('#trURL').hide();
									$("#menuPCD option:eq(0)").prop("selected", true);
								}
							},
							error : function() {
								
							},
							complete : function() {
								
							}
						});
					})
					.bind('move_node.jstree', function(e, data) {		
						data.rslt.o.each(function (i) {
							var currentId = $(this).attr("id");
							var parentId = data.rslt.np.attr("id");						
							//console.log(currentId);
							// 이동한 노드의 총 뎁스를 계산한다.
							var currentLvl = 1;
				
							// 자식 노드 리스트
							var childNodeList = $.jstree._focused()._get_children($(this));
							childNodeList.each(function(){
								currentLvl = 2;
								
								var thirdNodeList = $.jstree._focused()._get_children($(this));					
								thirdNodeList.each(function(){
									currentLvl = 3;
								});
							});
							
							var parentLvl = 0;
							if(parentId != 'menuTree'){
								parentLvl = $('#'+parentId).val();
							}							
							
							console.log('parentId: ' + parentId);
							console.log('currentLvl: ' + currentLvl);
							console.log('parentLvl: ' + parentLvl);
		
							// [move 체크 하여 조건에 맞지 않을 경우 경고창과 함께 롤백 시킨다.]
							// 1.현재 이동한 노드의 자식이 몇뎁스까지 존재하는지 파악
							// 1.1. 자식이 없을경우. 즉 1레벨 이거나 2레벨 이거나 3레벨일 경우 / 총뎁스:1
							//		2. 이동할 노드의 뎁스가 1이므로 최상위 노드, 1레벨노드, 2레벨 노드로 이동이 가능하다.
							// 1.2. 자식이 1뎁스 일경우. 즉 1레벨이거나 2레벨일 경우 / 총뎁스:2
							//		2. 이동할 노드의 뎁스가 이미 2뎁스 이기때문에 부모노드가 최상위 노드 이거나 1레벨 노드이어야만 가능하다.
							// 1.3. 자식이 2뎁스 일경우. 즉 1레벨일 경우 / 총뎁스 : 3
							//		2. 이미 현재 이동한 노드의 총 뎁스가 3이기 때문에 무조건 최상위 노드로 밖에 이동이 되지 않는다.
							//			즉 부모의 아이디는 무조건 트리아이디가  되어야 한다.
							console.log('총뎁스: ' + (Number(currentLvl) + Number(parentLvl)));
							if((Number(currentLvl) + Number(parentLvl)) > 3) {
								alert_popup("이동할 수 없습니다.");							
								$.jstree.rollback(data.rlbk);	// 이동시 불가능한 이동일 경우 롤백 시킨다.
							}else{
								
								var menuLvl = Number(parentLvl) + 1;
								var menuChildLvl = Number(parentLvl) + 2;
								
								var subMenuList = new Array();
								var subMenus = $('#' + parentId + '> ul').children();
								//console.log('child length: ' + $('#' + parentId).children().length);
								//console.log('childrens: ' + childrens.eq(0).attr('id'));
								
								for(var i = 0; i < subMenus.length; i++){
									subMenuList.push(subMenus.eq(i).attr('id'));
									console.log('subMenu: ' + subMenuList[i]);
								}
								// jstree는 탑메뉴 아이디가 menuTree임..
								// DB상에서는 탑메뉴 아이디가 ADMIN_MENU_TREE or HOMEPAGE_MENU_TREE임..
								if(parentLvl == 0){
									
									var menuTCD = $('#menuTCD').val();
									if(menuTCD == 'A') {
										parentId = 'ADMIN_MENU_TREE';
									}else if(menuTCD == 'H') {
										parentId = 'HOMEPAGE_MENU_TREE';
									}
								}		
								
								// 이동 프로세스 처리
								$.ajax({
									url: '/admin/updateMoveMenu.do',
									type: "post",
									data: {
										'menucd'		 :	currentId		// 이동한 메뉴 아이디
										,'up_cd'	 	 :	parentId		// 이동한 메뉴의 부모 아이디
										,'currentLvl'	 :  currentLvl  	// 현재 메뉴 레벨
										,'menu_lvl'		 :	menuLvl			// 변경된 메뉴 레벨
										,'cmenu_lvl'	 :	menuChildLvl	// 변경된 자식 메뉴 레벨
										,'subMenuList'	 :  subMenuList
									},
									dataType: "json",
									success: function(transport){
									},
									error: function(data){
										alert_popup('메뉴 이동 중 오류가 발생했습니다.');
									}
								});
							}						
						});
					})
				}
			}
		});
	}
	//메뉴 대상 추가 2020/05/07 - 추정완
	function fncMenuObject() {
		var selectBox = $('#menuTCD').val();
		return selectBox;
	}
	//메뉴 구분 링크 선택 시 URL창 노출 2020/05/08 - 추정완
	function fncURLToggle() {
		var selectBox = $('#menuPCD option:selected').val();
		if(selectBox == 'MENU_P001') {
			$('#trURL').show();
		}
		else if(selectBox == 'MENU_P002') {
			$('#trURL').show();
		}
		else if(selectBox == 'MENU_P003') {
			$('#trURL').show();
		}
		else{
			$('#trURL').hide();
		}
	}
</script>
<div class="contents">
   <div class="content_wrap">
   		<div class="cate_box fl wp40">
  			<div class="tree_st">
  				<!-- jsTree -->
   				<div id="menuTree" class="menuTree" style="border: solid 1px #BBB;"></div>
   			</div>
   		</div>  			
		<div class="fr wp60">
			<div class="table2">
				<!-- 메인테이블 -->
				<table class="main_table">
					<colgroup><col width="23%"/><col width="57%"/></colgroup>
					<tbody class="line">
						<tr>
							<th>메뉴 대상</th>
							<td class="left">
								<select id="menuTCD" class="form-control" onchange="fncMenuTreeSetting()" style="width : 130px">
									<option value="MENU_T001">홈페이지</option>
									<option value="MENU_T004">관리자</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>메뉴명</th>
							<td class="left">
								<input type="text" class="form-control" id="menuNm" onkeyup="validateInputVal('ko_en_num_blank', this)" style="width:300px">
							</td>
						</tr>
					</tbody>
				</table>
				<!-- 서브테이블 -->
				<table class="sub_table" hidden="true">
					<colgroup><col width="23%"/><col width="57%"/></colgroup>
					<tbody class="line">
						<tr>
							<th>메뉴 구분</th>
							<td class="left">
								<select id="menuPCD" class="form-control" onchange="fncURLToggle()" style="width : 130px">
									<option value="">-선택하세요-</option>
									<c:forEach items="${menuListPCD}" var="list">
										<option value="${list.commcd}">${list.cdnm}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>메뉴명 영어</th>
							<td class="left">
								<input type="text" class="form-control" id="menuNmEn" onkeyup="validateInputVal('en_num_blank', this)" style="width:300px">
							</td>
						</tr>
						<tr>
							<th>메뉴 설명</th>
							<td class="left"><textarea id="menuCmmt" class="form-control" rows="10" cols="40" onkeyup="validateInputVal('ko_en_num_blank', this)" style="width:300px"></textarea></td>
						</tr>
						<tr hidden="" id="trURL">
							<th>URL</th>
							<td class="left">
								<input type="text" size="40" id="menuURL" class="form-control" style="width:300px">
							</td>
						</tr>
						<tr>
							<th>사용여부</th>
							<td class="left">
								<input type="radio" name="menuUseYn" value="Y" checked="checked"><label>사용</label>&nbsp;&nbsp;<input type="radio" name="menuUseYn" value="N"><label>미사용</label>
							</td>
						</tr>
					</tbody>
				</table>
				<!-- 버튼 -->
				<div class="mTop15">
					<p class="fR">
						<button type="button" id="btnCancel" class="btn btn-primary btn-sm" style="display: none">취소</button>
						<button type="button" id="btnMenuInsert" class="btn btn-primary btn-sm non-display">등록</button>
						<button type="button" id="btnMenuUpdate" class="btn btn-primary btn-sm non-display">수정</button>
						<button type="button" id="btnMenuDelete" class="btn btn-primary btn-sm non-display">삭제</button>
					</p>
				</div>
			</div>
		</div>	
	</div>
</div> 