<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ page import="java.util.Date" %>
<%@ page import="java.net.*" %>

<script src="${pageContext.request.contextPath}/plugins/icheck/icheck.min.js"></script>
<script>

var list;
var i = 0;
var status = 0;

$(document).on('ready', function() {
	//doSearchApply();
});
window.onload = function(){
	setTimeout(function(){
		$('#moreApply').focus();
          }, 500);
}
    
//공지사항 상세보기 화면
function moveDetail(bitem_seq) {
	$('#bitemSeq').val(bitem_seq);
	var frm = document.frm2;
	frm.submit();
}    
function doDetail(project_seqno){
	$('#project_seqno').val(project_seqno);
	$('#frm4').submit();
	}
function doSubjectDetail(project_seqno){
	$('#project_seqno2').val(project_seqno);
	$('#frm3').submit();
}
function doNoticeDetail(notice_seqno){
	$('#notice_seqno').val(notice_seqno);
	var frm = document.frm5;
	frm.submit();
	//$('#frm5').submit();
}

function noticeList (){
	window.location.href = '/front/noticeList.do'
}

function layer_popup(el){

    var $el = $(el);    //레이어의 id를 $el 변수에 저장
    var $ep = $(el);
    var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

    isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();
	setTimeout(function(){
		$('.pop-container').focus();
   	}, 500);
	$('#skip_navigation').find("input, a, button").attr('tabindex','-1');
	$('#compaVcHead').find("input, a, button").attr('tabindex','-1');
	$('#compaVcContent').find("input, a, button").attr('tabindex','-1');
	$('.scroll-top fixed').find("input, a, button").attr('tabindex','-1');
	$('#compaVcFoot').find("input, a, button").attr('tabindex','-1');
    
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
        	$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
        	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
        	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
        	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
        	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        	setTimeout(function(){
        		$('#moreApply').focus();
           	}, 500);
            return false;
        }
    });

    $el.find('#btn-layerClose').click(function(){
    	$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
    	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	setTimeout(function(){
    		$('#moreApply').focus();
       	}, 500);
        return false;
    });

    $('.layer .dimBg').click(function(){
    	$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
    	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        $('.dim-layer').fadeOut();
        return false;
    });

}  

function doSearchApply(){
	$.ajax({
        url : "/front/noticePopupList.do",
        type: "get",
        data: '',
        dataType: "json",
        success : function(res){
            if(res.data.length>0){
            	list = res.data;
    	        popupNoticeView();
                }
	        
        },
        error : function(){
        	//alert('검색 실패하였습니다.');    
        	console.log("검색 실패");
        },
        complete : function(){
	        
        }
	}); 
}

//통보확인
function confirmNotice(){
	if(list.length > 0){
		var noticeSeq = list[i].notice_seqno;
		var url = "/front/noticeConfirm.do";
		var data = new FormData();
	 	data.append("notice_seqno",noticeSeq);
		$.ajax({
	        url : url,
	        type: "post",
	        processData: false,
	        contentType: false,
	        data: data,
	        dataType: "json",
	        success : function(res){
	        	i++;
	        	if(list.length>i){
	        		alert('통보 확인되었습니다.');
	        		
		        	}
	        	else{
	        		alert('통보 확인되었습니다.');
		        	}
	        	popupNoticeView();
	        },
	        error : function(){
	        	alert('통지 등록에 실패했습니다.');    
	        },
	        complete : function(){
	        }
		});
	}else if(list.length > 0){
		
		}
}

function popupNoticeView(){
	if(list.length > i){
		var ahtml = "";
			ahtml +='<table class="tbl">';
			ahtml +='<caption class="caption_hide">메인 통지 상세화면 페이지</caption>';
			ahtml +='<colgroup>';
			ahtml +='	<col style="width: 100px;">';
			ahtml +='	<col>';
			ahtml +='</colgroup>';
			ahtml +='<tbody>';
			ahtml +='	<tr>';
			ahtml +='		<th scope="col">제목</th>';
			ahtml +='		<td class="ta_left">'+list[i].notice_title+'</td>';
			ahtml +='	</tr>';
			ahtml +='	<tr>';
			ahtml +='		<th scope="col">통지일시</th>';
			ahtml +='		<td class="ta_left ">'+list[i].notice_send_date+'</td>';
			ahtml +='	</tr>';
			ahtml +='	<tr>';
			ahtml +='		<th scope="col">내용</th>';
			ahtml +='		<td class="ta_left">'+list[i].notice_contents+'</td>';
			/* ahtml +='	</tr>';
			if(list[i].fmst_seqno != null){
				for(var j=0; j<list[i].data.length;j++){
					ahtml +='	<tr>';
					ahtml +='		<th>첨부파일</th>';
					ahtml +='	<td>';
					ahtml +='		<a class="btn_step" href="/file/download.do?fmst_seq='+list[i].data[j].fmst_seq+'&fslv_seq='+list[i].data[j].fslv_seq+'">'+list[i].data[j].f_org_nm+'</a>';
					ahtml +='	</td>';
					ahtml +='	</tr>';
					} 
			}else{
				ahtml +='	<tr>';
				ahtml +='		<th>첨부파일</th>';
				ahtml +='	<td class="ta_left">첨부된 자료가 없습니다.</td>';
				ahtml +='	</tr>';
				} */
			ahtml +='</tbody>';
		ahtml +'=</table>';
		$('#applyData').empty();
		$('#applyData').append(ahtml); 
		console.log("화면그리기")
		var bhtml = "확인대상 통지건수 : "+parseInt(list.length- i) + " 건";
		setTimeout(function(){
			$('#list_size').text(bhtml);
			layer_popup("#layer2");
			console.log("다큐멘트레디")
           }, 1000);
		
	}else {
		$('.dim-layer').fadeOut();
		$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
    	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	setTimeout(function(){
			$('#moreApply').focus();
           }, 500);
		
	}
}

function moveBoard(board_seq){
	var action="/front/listBoardItem.do"
	
	var form = document.createElement('form');

	form.setAttribute('method', 'post');

	form.setAttribute('action', action);

	document.charset = "utf-8";

		var hiddenField = document.createElement('input');
		hiddenField.setAttribute('type', 'hidden');
		hiddenField.setAttribute('name', 'board_seq');
		hiddenField.setAttribute('value', board_seq);
		
		form.appendChild(hiddenField);
	document.body.appendChild(form);

	form.submit(); 	
}
</script>
<form action="/project/detail.do" id="frm4" name="frm4" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno" value="" />
</form>
<form action="/front/viewNotice.do" id="frm5" name="frm5" method="post">
	<input type="hidden" name=notice_seqno id="notice_seqno" value="" />
</form>
<form action="/subject/apply.do" id="frm3" name="frm3" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno2" value="" />
</form>
<form action="/front/viewBoardItem.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="bitemSeq" name="bitem_seq" value=""/>
	<input type="hidden" id="boardSeq" name="board_seq" value="100"/>
</form>

<form action="#" id="frm" name="frm" method="post">
	<input type="hidden" id="member_seqno" name="member_seqno" value="${member_seqno }"/>
	<!-- <div class="compaLginBg"></div> -->
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_content s:  -->
				<div class="area_cont">
					<div class="subject_corp">
						<h3 class="tbl_ttc">과제신청 대상사업 </h3>
						<!-- 건수 <span class="total_cnt">2 건</span> -->
						<p class="more_right"><a href="/project/list.do" class="btn_step" id="moreApply" title="과제신청 대상사업 더보기">더보기<span class="icon ico_go"></span></a></p>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">메인 과제신청 대상사업 리스트</caption>
							<colgroup>
								<col style="width:100px;"/>
								<col />
								<col style="width: 280px;"/>
								<col style="width: 100px;"/>
								<col style="width: 150px;"/>
							</colgroup>
							<thead>
								<tr>
									<th scope="col">사업년도</th>
									<th scope="col">사업명</th>
									<th scope="col">사업신청서 접수기간</th>
									<th scope="col">진행상태</th>
									<th scope="col">사업신청서 제출</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="apply" items="${result }" varStatus="status" end="4">
									<tr>
										<td>${apply.project_year}</td>
										<td class="ta_left">
											<a href="javascript:void(0);" onclick="doDetail('${apply.project_seqno}');" class="title_link" title="${apply.project_title}">${apply.project_title}</a>
										</td>
										<td>${apply.project_apply_sdate }~
												${apply.project_apply_edate }</td>
										<td>
											<c:if test="${ apply.project_proc_status eq 10}">
												<span class="lb lb_apply">임시저장</span>
											</c:if> 
											<c:if test="${ apply.project_proc_status eq 99}">
												<span class="lb lb_apply">취소</span>
											</c:if>
											<c:choose>
												<c:when test="${ apply.project_proc_status eq 20 and apply.edate_chk eq 'N' and apply.sdate_chk eq 'N'}">
													<span class="lb lb_ing">접수중</span>
												</c:when>
												<c:when test="${ apply.project_proc_status eq 50}">
													<span class="lb lb_apply">접수완료</span>
												</c:when>
												<c:when test="${ apply.edate_chk eq 'Y' and apply.project_proc_status eq 20}">
													<span class="lb lb_end">접수마감</span>
												</c:when>
												<c:when test="${ apply.sdate_chk eq 'Y' }">
													<span class="lb lb_convention">접수예정</span>
												</c:when>
											</c:choose>
										</td>
										<td>
											<c:choose>
												<c:when test="${ apply.project_proc_status eq 20 and apply.edate_chk eq 'N' and apply.sdate_chk eq 'N'}">
													<button type="button" onclick="doSubjectDetail('${apply.project_seqno}' );" class="btn_step" title="신청관리 버튼">
												신청관리<span class="icon ico_go"></span></button>
												</c:when>
												<c:otherwise>
													-
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
								<c:if test="${empty result}">
									<tr>
										<td colspan="5">
										등록된 사업공고가 없습니다.
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
					<div class="subject_corp">
						<h3 class="tbl_ttc">사업신청 및 과제수행 현황</h3>
						<p class="more_right"><a href="/subject/applyList.do" class="btn_step" title="사업신청 및 과제수행 현황 더보기">더보기<span class="icon ico_go"></span></a></p>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">메인 사업신청 및 과제수행 현황 리스트</caption>
							<colgroup>
								<col style="width:100px;"/>
								<col />
								<col style="width: 280px;"/>
								<col style="width: 100px;"/>
								<col style="width: 150px;"/>
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">사업명</th>
									<th scope="col">사업수행기간</th>
									<th scope="col">진행상태</th>
									<th scope="col">신청관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="subject" items="${resultJoin }" varStatus="statusJoin" >
									<tr>
										<td>${subject.project_year }</td>
										<td class="ta_left">${subject.project_title } </td>
										<td>${subject.subject_sdate } ~ ${subject.subject_edate }</td>
										<td>
											<c:if test="${subject.subject_proc_status eq 10}">
											<span class="lb lb_apply">임시저장</span>
											</c:if> 
											<c:if test="${subject.subject_proc_status eq 20}">
											<span class="lb lb_ing">사업신청</span>
											</c:if> 
											<c:if test="${subject.subject_proc_status eq 30}">
											<span class="lb lb_apply">신청심사</span>
											</c:if> 
											<c:if test="${subject.subject_proc_status eq 50}">
											<span class="lb lb_apply">승인</span>
											</c:if>
											<c:if test="${subject.subject_proc_status eq 80}">
											<span class="lb lb_apply">보완</span>
											</c:if>
											<c:if test="${subject.subject_proc_status eq 90}">
											<span class="lb lb_apply">거부</span>
											</c:if>
											<c:if test="${subject.subject_proc_status eq 99}">
											<span class="lb lb_apply">취소</span>
											</c:if>
										</td>
										<td><a href="javascript:void(0);" onclick="doSubjectDetail('${subject.project_seqno}')" class="btn_step" title="신청관리">신청관리<span class="icon ico_go"></span></a></td>
									</tr>
								</c:forEach>
								<c:if test="${empty resultJoin}">
									<tr>
										<td colspan="5">
										참여한 사업공고가 없습니다.
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
					
					<div class="wrap_support">
						<div class="notice_box">
							<div class="notice_top_area">
								<h3 class="tit_corp">공지사항</h3>
								<p class="more_right"><a href="javascript:void(0);" onclick="moveBoard('100');" class="btn_step" title="공지사항">더보기<span class="icon ico_go"></span></a></p>
							</div>
							<ul class="list_question">
								<c:choose>
									<c:when test="${ not empty notice }">
			 							<c:forEach var="notice" items="${ notice }" end="4">
											<li><a href="javascript:void(0);" onClick="moveDetail('${ notice.bitem_seq }');return false" title="공지사항 바로가기" class="title_link" >
											<c:if test="${ notice.new_mark eq 'Y' }"><span class="red">[NEW]&nbsp;</span></c:if>
											${ notice.bitem_title }</a><span class="link_date">${ notice.regdtm }</span></li>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<li style="text-align: center; font-size: 16px">
											등록된 공지사항이 없습니다.
										</li>
									</c:otherwise>
								</c:choose>  				
							</ul>
						</div>
						<div class="notice_box">
							<div class="notice_top_area">
								<h3 class="tit_corp">통지목록</h3>
								<p class="more_right"><a href="/front/noticeList.do" class="btn_step" title="통지목록 더보기">더보기<span class="icon ico_go"></span></a></p>
							</div>
							<ul class="list_question">
								<c:choose>
									<c:when test="${ not empty noticeFront }">
			 							<c:forEach var="notice" items="${ noticeFront }" end="4">
											<li><a href="javascript:void(0);" onClick="doNoticeDetail('${ notice.notice_seqno }');return false" title="통지 바로가기" class="title_link" >
											<c:if test="${ notice.new_mark eq 'Y' }"><span class="red">[NEW]&nbsp;</span></c:if>
											${ notice.notice_title }</a><span class="link_date">${ notice.notice_send_date }</span></li>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<li style="text-align: center; font-size: 16px">
											등록된 통지목록이 없습니다.
										</li>
									</c:otherwise>
								</c:choose>  
							</ul>
						</div>
					</div>
				</div>
				<!-- //page_content e:  -->
			</div>
		</div>
	</div>
	
	<!-- 통지관리 popup -->
	<div class="dim-layer" id="notice_layer">
    <div class="dimBg"></div>
    <div id="layer2" class="pop-layer" style="height:350px;width:600px;">
        <div class="pop-container">
        <div class="pop-title"><h3>통지</h3><button class="btn-layerClose" id="btn-layerClose" title="통지 버튼"><span class="icon ico_close" title="팝업닫기">팝업닫기</span></button></div>
        
            <div class="pop-conts" style="text-align:right;">
            	<span id="list_size"></span>
                <!--content //-->
               <!-- <p class="pop-info">검색할 공급기관에 사업자번호를 입력하세요.</p> -->
             <!--   <div class="form-inline pop-search-box"> 
	               <input type="hidden" id="searchApply" name="searchApply"  style="width:260px"/>
	               
               </div> -->
               <div style="overflow-y:auto; height:500px;width:550px;">
               
	               <div class="tbl_comm tbl_public" id="applyData" style="margin-top:10px" ></div>
	               <div style="text-align:center;margin-top:10px;">
					<button type="button" onClick="confirmNotice();" class="btn_step" title="통지 확인 버튼">확인</button>
					<button type="button" onClick="noticeList();" class="btn_step" title="통지 목록으로 이동 버튼">목록으로 이동</button>
					</div>
                <!--// content-->
            </div>
        </div>
    	</div>
	</div>
</div>
	
</form>