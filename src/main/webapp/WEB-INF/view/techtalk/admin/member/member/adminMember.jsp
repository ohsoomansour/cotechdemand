<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
.ui-jqgrid .ui-jqgrid-htable th div {
    height:25px;
}
.ui-jqgrid-pager {
	z-index: 0!important;
}
.list_top {
	margin-bottom: 10px;
}
.pop-layer {
	z-index: 99;
}
</style>

<script>
	$(document).ready(function(){
		
		initDatePicker([$('#strDate'), $('#endDate')]);
		
		$("#list").jqGrid({
<<<<<<< HEAD
			url : '/admin/listMember.do', 
=======
			url : '/admin/listMemberX.do', 
>>>>>>> branch 'develop' of https://git.ttmsoft.co.kr/wert/tibiz.git
			mtype : 'POST',
			datatype : 'json',
			postData:{},
			colNames : [
						"회원번호",
						"가입일자",
						"회원종류",
						"아이디",
						"이름",
						"개인이메일",
						"휴대번호",
						"회사 이름",
				  		"업무용이메일",
						"회사 직통번호",
						"탈퇴여부",
						"가입승인"
						//"권한"	
			],
			colModel : [
				{name:'member_seqno', 		index:'member_seqno',		width:30,			align:'center'},
				{name:'regist_date', 		index:'regist_date',		width:40,			align:'center'},
				{name:'member_type', 		index:'member_type',			width:30,			align:'center'},						
				{name:'id', 				index:'id',					width:30,			align:'center'},
				{name:'user_name', 			index:'user_name',			width:30,			align:'center'},
				{name:'user_email', 		index:'user_email',			width:80,			align:'center'},
				{name:'user_mobile_no', 	index:'user_mobile_no',			width:40,			align:'center'},
				{name:'biz_name', 			index:'biz_name',			width:50,			align:'center'},
				{name:'biz_email', 			index:'biz_email',			width:80,			align:'center'},
				{name:'biz_tel_no', 		index:'biz_tel_no',			width:40,			align:'center'},
				{name:'delete_flag', 		index:'delete_flag',			width:20,			align:'center'},
				{name:'agree_flag', 			index:'agree_flag',				width:40,			align:'center', formatter: renderAgreeBtn}
			],
			pager: $('#pager'), 
			rowNum:10,
			rowList:[10, 20, 30],
			jsonReader: {
				root : 'rows',
	            total : 'total',
	            page : 'page',
	            repeatitems : false
			},
			viewrecords: true,
			imgpath : "",
			caption : "",
			autowidth: true,
			height: 'auto',
			//loadonce: true,
			multiselect: true,
			shrinkToFit: true,
			multiboxonly : true,
			loadComplete: function(data){
				// set totalCount 
				$('#totalCount').text(data.records);

				/*
					var ids = $('#list').getDataIDs();  //아이디 추정됨: tlo, test, business

					console.log(data);


					data.array.forEach(element => {
						
					});
	
					var linkId = '';
					var useYn = '';
					for (var i = 0; i < ids.length; i++) {
					
							var rowData = $('#list').getRowData(ids[i]);

							var cl = ids[i];
							console.log("cl:" + cl); // cl: testdes >> cl:test2 
							
							
							//------------ 23.09.01 가입승인 --------------- 멤버타입이 session에서 불러와야됨 
							var btnModifyAuth = "<button id= 'approved_"+rowData.member_seqno+"' class='btn btn-default btn-sm' onclick=" + 'fncAuthView("Y","' + rowData.member_seqno + '")' + ">승인</button>";
							
							$('#list').setRowData(cl, {
									button : btnModifyAuth
							});
							//beforeLoad(rowData.member_seqno ); //로드 되기 전 가입 승인 확인 
					}; 
				*/	
					/*$('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
					$(window).on('resize.jqGrid', function () {
							$('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
					});*/
				
                
			},         
			//END loadComplete1

		});	// jqgrid 끝
				
		// 전체 SMS 버튼 2020/03/23 - 추정완
		$('#btnSendSmsAll').click(function(event) {
 			event.preventDefault();
		});
		
		// SMS발송 버튼 2020/03/23 - 추정완
		$('#btnSendSms').click(function(event) {
 			event.preventDefault();
		});
		
		// 검색 버튼 2020/03/20 - 추정완
		$('#btnSearch').click(function(event) {
			event.preventDefault();
			fncList();  // 'reloadGird 함수'를 실행하면서 데이터를 새로 가져오게 된다. 
		});
		// 포인트 지급 버튼	2020/04/29 - 박인정
		$('#btnUpdatePoint').click(function(event) {
			event.preventDefault();
			fncUpdatePoint();
		});

		$('#filterBtn').click(function() {
			var $href = "#filterPop";
			var cls = "filterPop";
			var op = $(this);
				layer_popup($href, cls, op);
		});

		setCheckBoxGroup('input[name=agree_join]');
		setCheckBoxGroup('input[name=member_type]');

		setDateInputGroup($('#strDate'), $('#endDate'));

		$('#keyword').keydown(function(event) {
			if ( event.keyCode && event.keyCode == 13 ) {
				doSearch();
			}
		})

	});	//jquery 종료

	function isNotEmpty(value) {
		return (value != undefined && value != '')? true : false;
	}

	function renderAgreeBtn(cellvalue, options, rowObject) {
		var text = (cellvalue == 'Y')? '승인완료' : '승인';
		return `<button id="approved_\${rowObject.member_seqno}" class="btn btn-default btn-sm"  onclick="fncAuthView('Y','\${rowObject.member_seqno}')">\${text}</button>`;
	}

	function setCheckBoxGroup(targetName) {
		$(targetName).click(function(e){
			$(targetName).each(function(index, value){
				value.checked = false;
			})
			e.currentTarget.checked = true;
		});
	}

	function setDateInputGroup($start, $end) {

		$start.change(function(e){
			var val = e.currentTarget.value;
			var endVal = $end.val();
			if(isNotEmpty(val) || isNotEmpty(endVal)) {
				setDateAllCheck(false)
			}else{
				setDateAllCheck(true)
			}
		});

		$end.change(function(e){
			var val = e.currentTarget.value;
			var startVal = $start.val();
			if(isNotEmpty(val) || isNotEmpty(startVal)) {
				setDateAllCheck(false)
			}else{
				setDateAllCheck(true)
			}
		});

		$('#date_all').click(function(){
			$start.val('');
			$end.val('');
		});
	}

	function setDateAllCheck(checked) {
		$('#date_all').prop('checked', checked);
	}
	
	// 조회 - 2023/09/01 ~  추정 중
	function fncList(data) {
	
        $('#list').setGridParam({
        	datatype : 'json',
            postData : data,    
        });
    	$('#list').setGridParam({
			page : 1
		});
		$('#list').trigger('reloadGrid');
	}
	
<<<<<<< HEAD
	//가입 승인 이미 되어있음: 버튼을 누르기에 승인완료 처리
	function beforeLoad(seqno){
		$.ajax({
			type : 'GET',
			url : '/admin/joinAgreementConfirm.do?seqno=' + seqno,
			dataType : 'json',
			success : function(data) {
				console.log(data) //joinApprovedConfirm: {agree_flag: 'Y'}
				var joinApprovedConfirm = data.joinApprovedConfirm.agree_flag

				if(joinApprovedConfirm === 'Y') {
					refresh(seqno);
				}else if(joinApprovedConfirm === 'N'){
					return null;
				}
			},
			error : function() {
				console.log("로드하기 전 에러났다 고쳐라")
			}
		}) 
	}
		
	
	
    //meber_type이 ADMIN일 경우 가입 승인 가능
    function fncAuthView(mode, seqno ) {
=======
    //meber_type이 ADMIN일 경우 가입 승인 가능ㅁ
	function fncAuthView(mode, seqno ) {
>>>>>>> branch 'develop' of https://git.ttmsoft.co.kr/wert/tibiz.git
    	var member_type = '<%=(String)session.getAttribute("member_type")%>';
    	var member_id = '<%=(String)session.getAttribute("id")%>';
    	console.log("session: member_type:" + member_type);
    	if(member_type === "ADMIN" ){
	    	$.ajax({
					type : 'GET',
<<<<<<< HEAD
					url : '/admin/joinAgreementConfirm.do?seqno=' + seqno,
=======
					url : '/admin/joinAgreementConfirmX.do?seqno=' + seqno,
>>>>>>> branch 'develop' of https://git.ttmsoft.co.kr/wert/tibiz.git
					dataType : 'json',
					success : function(data) {
						console.log(data) //joinApprovedConfirm: {agree_flag: 'Y'}
						var joinApprovedConfirm = data.joinApprovedConfirm.agree_flag;
	
						if(joinApprovedConfirm === 'N') {
							var url = '/admin/agreeMemberAuthX.do?mode=' + mode + '&seqno=' + seqno  ;
					    	var config={
								headers:{
									"Content-Type":"application/json;charset=utf-8",
								},
								method:"POST"		
							};
					    	
					    	//seqno의해 agree_flag = 'Y'로 변경 (*현재 DB에 기입)
					    	fetch(url, config);
					    	refresh(seqno);
						}
					},
					
					error : function() {
						
					},
					complete : function() {
						
					}
			}); //ajax 끝 
    	}
    }

	//파라미터를 seqno, member_type를 받아와서 == 'ADMIN'만 변경해줌
	function refresh(seqno){
			$('#approved_' + seqno).html("승인완료");	
	}

	function layer_popup(el, cls, op){
		var $el = $(el);    //레이어의 id를 $el 변수에 저장
		var $op = $(op);    //레이어의 id를 $el 변수에 저장
		var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

		isDim ? $("."+cls).fadeIn() : $el.fadeIn();
		var inputId = $("."+cls).find("input").first().attr('id');
		setTimeout(function(){
			$('#'+inputId).focus();
				}, 500);

		var $elWidth = ~~($el.outerWidth()),
				$elHeight = ~~($el.outerHeight()),
				docWidth = $(document).width(),
				docHeight = $(document).height();

		// 화면의 중앙에 레이어를 띄운다.
		if ($elHeight < docHeight || $elWidth < docWidth) {
				$el.css({
						marginTop: -$elHeight /2,
						marginLeft: -$elWidth/2
				})
		} else {
				$el.css({top: 0, left: 0});
		}

		//esc키 버튼 입력시 통보 없애기
		$(document).keydown(function(event) {
				if ( event.keyCode == 27 || event.which == 27 ) {
						$('.compaLginCont').find("input, a, button").removeAttr('tabindex');
						$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
					isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
					setTimeout(function(){
							$op.focus();
							}, 500);
						return false;
				}
		});


		$el.find('.btn_cancel,.btn-layerClose').click(function(){
				isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
				
				setTimeout(function(){
					$op.focus();
					}, 500);
				return false;
		});

		$('#submitFilterBtn').click(function(){
			isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
				
			setTimeout(function(){
				$op.focus();
				}, 500);
			return false;
		});

	}

	function doSearch() {
		var keyword = $('#keyword').val();

		if(isNotEmpty(keyword)) {
			fncList({
				keyword: keyword
			});
		}else{
			fncList({
				keyword: ''
			});
		}
	}
  
	function doSearchFilter() {
		var result = {};
		var dateFilter = getDateFilter();
		var memberTypeFilter = $('input[name=member_type]').filter(':checked').val();
		var agreeJoinFilter = $('input[name=agree_join]').filter(':checked').val();

		if(dateFilter != null) {
			if(isNotEmpty(dateFilter[0])) {
				result['strdate'] = dateFilter[0].replace(/-/gi, "");
			}

			if(isNotEmpty(dateFilter[1])) {
				result['enddate'] = dateFilter[1].replace(/-/gi, "");
			}
		}

		if(memberTypeFilter != 'ALL' && isNotEmpty(memberTypeFilter)){
			result['member_type'] = memberTypeFilter;
		}

		if(agreeJoinFilter != 'ALL' && isNotEmpty(agreeJoinFilter)){
			result['agree_value'] = agreeJoinFilter;
		}

		fncList(result);
	}

	function getDateFilter() {
		var checkAll = $('date_all').is(':checked');

		if(!checkAll){
			return [$('#strDate').val(), $('#endDate').val()]
		}

		return null;
	}
	
</script>


<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont" >
            <!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">회원 목록</h3>
			</div>
			<div class="area_cont">
				<div class="list_panel" id="tbl">
					<div class="cont_list">
						<div class="list_top">
							<p>count : <span id="totalCount">0</span>건</p>
							<div class="list_top_util ">
								<div class="search_box_inner">
									<div class="btn_box">
										<button type="button" class="btn_default"  title="필터" id="filterBtn">
											<i class="icon_filter"></i>
											<span>필터</span>
										</button>
									</div>
									<div class="search_keyword_box">
										<input type="text" class="keyword_input" id="keyword" name="keyword" value="${paraMap.keyword}" placeholder="키워드를 입력하세요." value="" title="검색어">
									</div>
									<div class="btn_wrap">
										<button type="button" class="btn_step" onClick="javascript:doSearch();" title="검색">
											<span>검색</span>
										</button>
									</div>
								</div>
							</div>
						</div>
						
						<!-- grid start -->
						<div id="gridWrapper" class="mTop20">
						<table id="list" class="scroll"></table> 
						<div id="pager" class="scroll"></div> 
						<!-- grid end -->

					</div>
				</div>
				<!-- paging -->
				<div class="paging_comm">${sPageInfo}</div>
           	</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>

<div class="dim-layer filterPop" >
	<div class="dimBg"></div>
	<div id="filterPop" class="pop-layer" style="height:420px;width:640px">
			<div class="pop-container">
			<div class="pop-title"><h3>필터</h3><button class="btn-layerClose" title="팝업닫기"><span class="icon ico_close">팝업닫기</span></button></div>
					<div id="tap1_1" style="display: block">
			<div class="tbl_view tbl_public tr_tran" style="margin-top:0">
				<table class="tbl">
					<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">필터</caption>
					<colgroup>
						<col style="width:150px"/><col />
					</colgroup>
					<thead></thead>
					<tbody class="line">
						<tr>
							<th scope="col">가입일자</th>
							<td class="left form-inline">
								<div class="btn_chk div-inline">
									<input type="checkbox" name="date_all"  id="date_all" value="date_all" checked> 
									<label for="date_all" class="option_label">  
										<span class="inner"><span class="txt_checked">전체</span></span> 
									</label>
								</div>
								<div class="datepicker_wrap">
									<input type="text" id="strDate" name="strDate" class="form-control">
									~
									<input type="text" id="endDate" name="endDate" class="form-control">
								</div>
								
							</td>
						</tr>
						<tr>
							<th scope="col">회원종류</th>
							<td class="left form-inline">
								<div class="btn_chk div-inline">
									<input type="checkbox" name="member_type" id="member_type_ALL" value="ALL" checked> 
									<label for="member_type_ALL" class="option_label">  
										<span class="inner"><span class="txt_checked">전체</span></span> 
									</label>
								</div>
								<div class="btn_chk div-inline">
									<input type="checkbox" name="member_type" id="member_type_R" value="R"> 
									<label for="member_type_R" class="option_label">  
										<span class="inner"><span class="txt_checked">연구자</span></span> 
									</label>
								</div>
								<div class="btn_chk div-inline">
									<input type="checkbox" name="member_type" id="member_type_B" value="B"> 
									<label for="member_type_B" class="option_label">  
										<span class="inner"><span class="txt_checked">기업</span></span> 
									</label>
								</div>
								<div class="btn_chk div-inline">
									<input type="checkbox" name="member_type" id="member_type_TLO" value="TLO"> 
									<label for="member_type_TLO" class="option_label">  
										<span class="inner"><span class="txt_checked">TLO</span></span> 
									</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="col">승인여부</th>
							<td class="left form-inline">
								<div class="btn_chk div-inline">
									<input type="checkbox" name="agree_join"  id="agree_join_ALL" value="ALL" checked> 
									<label for="agree_join_ALL" class="option_label">  
										<span class="inner"><span class="txt_checked">전체</span></span> 
									</label>
								</div>
								<div class="btn_chk div-inline">
									<input type="checkbox" name="agree_join"  id="agree_join_N" value="N"> 
									<label for="agree_join_N" class="option_label">  
										<span class="inner"><span class="txt_checked">승인</span></span> 
									</label>
								</div>
								<div class="btn_chk div-inline">
									<input type="checkbox" name="agree_join"  id="agree_join_Y" value="Y"> 
									<label for="agree_join_Y" class="option_label">  
										<span class="inner"><span class="txt_checked">승인완료</span></span> 
									</label>
								</div>
							</td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>
				<div class="tbl_public" >
					<div style="text-align:center;margin-top:40px;">
							<button type="button" class="btn_step btn_point_black" id="submitFilterBtn" onClick="javascript:doSearchFilter();"  title="적용">적용</button>
							<button type="button" class="btn_line btn_cancel" id="cancelId"  name="btnCancel" title="닫기">닫기</button>
						</div>
					</div>
			</div>
		</div>
			</div>
	 </div>
</div>