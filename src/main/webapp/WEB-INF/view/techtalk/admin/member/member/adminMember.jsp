<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
	$(document).ready(function(){
		
		initDatePicker([$('#strDate'), $('#endDate')]);
		
		$("#list").jqGrid({
			url : '/front/listMember.do', 
			mtype : 'POST',
			datatype : 'json',
			postData:{
				member_seqno:$('#member_seqno').val()
			},
			colNames : [
						"member_seqno",
						"가입일자",
						"회원종류",
						"아이디",
						"이름",
						"개인이메일",
						"휴대번호",
						"회사 이름",
				  		"업무용이메일",
						"회사 직통번호",
						"가입승인"
						//"권한"	
			],
			colModel : [
						{name:'member_seqno', 		index:'member_seqno',		width:40,			align:'center'},
						{name:'regist_date', 		index:'regist_date',		width:40,			align:'center'},
						{name:'member_type', 		index:'membertype',			width:20,			align:'center'},						
						{name:'id', 				index:'id',					width:30,			align:'center'},
						{name:'user_name', 			index:'username',			width:30,			align:'center'},
						{name:'user_email', 		index:'useremail',			width:80,			align:'center'},
						{name:'user_mobile_no', 	index:'mobileno',			width:40,			align:'center'},
						{name:'biz_name', 			index:'biz_name',			width:50,			align:'center'},
						{name:'biz_email', 			index:'biz_email',			width:80,			align:'center'},
						{name:'biz_tel_no', 		index:'biz_tel_no',			width:40,			align:'center'},
						{name:'button', 			index:'button',				width:60,			align:'center'}

			],
			pager: $('#pager'), 
			rowNum:15,
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
			loadComplete: function(){
				var ids = $('#list').getDataIDs();  //아이디 추정됨: tlo, test, business
	
                var linkId = '';
                var useYn = '';
                for (var i = 0; i < ids.length; i++) {
                
                    var rowData = $('#list').getRowData(ids[i]);  // rowData = [Object, Object]

                    var cl = ids[i];
                    console.log("cl:" + cl); // cl: testdes >> cl:test2 
                    
                    
                    //------------ 23.09.01 가입승인 --------------- 멤버타입이 session에서 불러와야됨 
                   var btnModifyAuth = "<button id= 'approved_"+rowData.member_seqno+"' class='btn btn-default btn-sm' onclick=" + 'fncAuthView("Y","' + rowData.member_seqno + '")' + ">승인</button>";
                    
                    $('#list').setRowData(cl, {
                        button : btnModifyAuth
                    });
                    beforeLoad(rowData.member_seqno ); //로드 되기 전 가입 승인 확인 
                }; 
                
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
	});	//jquery 종료
	
	// 조회 - 2023/09/01 ~  추정 중
	function fncList() {
	
        $('#list').setGridParam({
        	datatype : 'json',
            postData : {
            	division_type : $("#divisionType").val(),
            	division_value : $("#divisionValue").val(),       	
            	agree_value : $('#guide option:selected').val(),
            	//student_state : $("#studentState").val(),
            	strdate : $("#strDate").val().replace(/-/gi, ""),
            	enddate : $("#endDate").val().replace(/-/gi, ""),
            	//strage : $("#strAge").val(),
            	//endage : $("#endAge").val(),
            	//major : $('#major').val()
            },    
        });
    	$('#list').setGridParam({
			page : 1
		});
		$('#list').trigger('reloadGrid');
	}
	
	//가입 승인 이미 되어있음: 버튼을 누르기에 승인완료 처리
	function beforeLoad(seqno){
		$.ajax({
			type : 'GET',
			url : '/front/joinAgreementConfirm.do?seqno=' + seqno,
			dataType : 'json',
			success : function(data) {
				console.log(data) //joinApprovedConfirm: {agree_flag: 'Y'}
				var joinApprovedConfirm = data.joinApprovedConfirm.agree_flag;

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
		
	
	
    //meber_type이 ADMIN일 경우 가입 승인 가능ㅁ
    function fncAuthView(mode, seqno ) {
    	var member_type = '<%=(String)session.getAttribute("member_type")%>';
    	console.log(member_type);
    	if(member_type === "ADMIN" ){
	    	$.ajax({
					type : 'GET',
					url : '/front/joinAgreementConfirm.do?seqno=' + seqno,
					dataType : 'json',
					success : function(data) {
						console.log(data) //joinApprovedConfirm: {agree_flag: 'Y'}
						var joinApprovedConfirm = data.joinApprovedConfirm.agree_flag;
	
						if(joinApprovedConfirm === 'N') {
							var url = '/front/agreeMemberAuth.do?mode=' + mode + '&seqno=' + seqno  ;
					    	var config={
								headers:{
									"Content-Type":"application/json;charset=utf-8",
								},
								method:"PUT"		
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
    
	
</script>

<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <div class="area_cont ">
	                <div class="subject_corp">
	                    <h4>기본정보</h4>
	                </div>
	                <div class="sub_list" style="width : 80%">
				   		<table class="table1" >
							<colgroup><col width="7%"/><col width="43%"/><col width="7%"/><col width="43%"/></colgroup>
							<tr>
								<th>구분</th>
								<td class="form-inline">
									<select id="divisionType" name="divisionType" class="form-control">
										<option value="all">전체</option>
										<option value="userId">아이디</option>
										<option value="userNm">이름</option>
										<option value="mPhone">전화번호</option>
									</select>
									<input type="text" id="divisionValue" name="divisionValue" class="form-control w300">
								</td>
							</tr>
							<tr>
								<th>가입일자</th>
								<td class="form-inline">
									<input type="text" id="strDate" name="strDate" class="form-control">
									~
									<input type="text" id="endDate" name="endDate" class="form-control">
								</td>
							</tr> 
							 <tr>
								<th>가이드 신청 여부</th>
								<td class="form-inline">
									<select id="guide" class="form-control">
										<option value="">전체</option>
										<c:forEach items="${guideList}" var="guide">
											<option value="${guide}">${guide}</option>
										</c:forEach>
									</select>
								</td> 
							</tr> 
							<!--  
							 <tr>
								<th>연령대</th>
								<td class="form-inline">
									<input type="text" id="strAge" name="strAge" class="form-control w80" onkeyup="validateInputVal('num', this)">
									~
									<input type="text" id="endAge" name="endAge" class="form-control w80" onkeyup="validateInputVal('num', this)">
								<td>
							</tr> -->
						</table> 
						<div class="btnWrap alignRight mTop10">
							<button type="button" id= "btnSearch" name="btnSearch" class="btn btn-primary btn-sm" >검색</button>
						</div>
				   	</div>
	                <div class="tbl_view tbl_public">
	                
	                <div id="gridWrapper" class="mTop20">
						<table id="list" class="scroll"></table> 
						<div id="pager" class="scroll"></div> 
					</div>
		            </div>
				</div>
            <div class="wrap_btn _center">
            	<p></p>
                <a href="javascript:history.back();" class="btn_cancel" title="취소">취소</a>
                <a href="javascript:fncMemberJoin();" class="btn_confirm" title="회원가입">회원가입 </a>
                <!-- <a href="javascript:fncSetData();" class="btn_confirm">데이터입력 </a> -->
            </div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
