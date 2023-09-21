<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function() {
	var startIndex = 1;	// 인덱스 초기값
	
	$("#lessProButton").hide();
	$("#lessPatentButton").hide();
		
	$('#moreProButton').click(function() {
		$("#lessProButton").show();
		$("#moreProButton").hide();
		
	});

	$('#lessProButton').click(function() {
		$("#moreProButton").show();
		$("#lessProButton").hide();
	});
	
	$('#morePatentButton').click(function() {
		$("#lessPatentButton").show();
		$("#morePatentButton").hide();
		
	});

	$('#lessPatentButton').click(function() {
		$("#morePatentButton").show();
		$("#lessPatentButton").hide();
	});

});

//국가 과제 수행 이력 더보기 이벤트
function moreProContens(){
	
	var list = new Array();
	<c:forEach items="${proData}" var="list">
		var proItem ={};
		proItem.re_project_nm = "${list.re_project_nm}";
		proItem.re_institu_nm = "${list.re_institu_nm}";
		proItem.re_start_date = "${list.re_start_date}";
		proItem.re_end_date = "${list.re_end_date}";
		list.push(proItem);
	</c:forEach>

	for(var i = 0; i < list.length; i++){
		var ahtml= "";
		ahtml +="<table class='tbl'>"
			ahtml +="<caption class='caption_hide'>국가 과제 수행 이력</caption>"
			ahtml +="<colgroup>"
			ahtml +="<col ' />"
			ahtml +="<col  />"
			ahtml +="<col  />"
			ahtml +="</colgroup>"
			ahtml +="<thead>"
			ahtml +="<tr>"
			ahtml +="<th>과제명</th>"
			ahtml +="<th>과제관리기관</th>"
			ahtml +="<th>연구기관</th>"
			ahtml +="<tr>"
			ahtml +="</thead>"
			ahtml +="<tbody>"
			if(list[0].re_project_nm != '' && list[0].re_project_nm != 0){
					
				for(var i=0; i<list.length;i++){
				ahtml +="<tr>"
					ahtml +=	"<td class='ta_left'>"+list[i].re_project_nm+"</td>"
					ahtml +=	"<td >"+list[i].re_institu_nm+"</td>"
					ahtml +=	"<td >"+list[i].re_start_date+" ~ "
					ahtml +=	list[i].re_end_date+"</td>"
				ahtml +="<tr>"
				}
			}else{
				ahtml +=	"<td colspan='3'>국가 과제 수행 이력이 확인되지 않았습니다.</td>"
			}
	   ahtml +="</tbody>"
		ahtml +="</table>"
		$('#tbl2').empty();
    	$('#tbl2').append(ahtml);
	}
	
}

//국가 과제 수행 이력 줄이기 이벤트
function lessProContens(){

	var list = new Array();
	<c:forEach items="${proData}" var="list">
		var proItem ={};
		proItem.re_project_nm = "${list.re_project_nm}";
		proItem.re_institu_nm = "${list.re_institu_nm}";
		proItem.re_start_date = "${list.re_start_date}";
		proItem.re_end_date = "${list.re_end_date}";
		list.push(proItem);
	</c:forEach>
	
	for(var i = 0; i < 5; i++){
		console.log(list);
		var ahtml= "";
		ahtml +="<table class='tbl'>"
			ahtml +="<caption class='caption_hide'>국가 과제 수행 이력</caption>"
			ahtml +="<colgroup>"
			ahtml +="<col ' />"
			ahtml +="<col  />"
			ahtml +="<col  />"
			ahtml +="</colgroup>"
			ahtml +="<thead>"
			ahtml +="<tr>"
			ahtml +="<th>과제명</th>"
			ahtml +="<th>과제관리기관</th>"
			ahtml +="<th>연구기관</th>"
			ahtml +="<tr>"
			ahtml +="</thead>"
			ahtml +="<tbody>"
			if(list[0].re_project_nm != '' && list[0].re_project_nm != 0){
				for(var i=0; i<5; i++){
					ahtml +="<tr>"
						ahtml +=	"<td class='ta_left'>"+list[i].re_project_nm+"</td>"
						ahtml +=	"<td >"+list[i].re_institu_nm+"</td>"
						ahtml +=	"<td >"+list[i].re_start_date+" ~ "
						ahtml +=	list[i].re_end_date+"</td>"
					ahtml +="<tr>"
					}
			}else{
				ahtml +=	"<td colspan='3'>국가 과제 수행 이력이 확인되지 않았습니다.</td>"
			}
		
	   ahtml +="</tbody>"
		ahtml +="</table>"
		$('#tbl2').empty();
    	$('#tbl2').append(ahtml);
	}
}

//특허리스트 더보기 이벤트
function morePatentContens(){
	
	var list = new Array();
	<c:forEach items="${patentData}" var="list">
		var item ={};
		item.invent_nm = "${list.invent_nm}";
		item.applicant_no = "${list.applicant_no}";
		item.applicant_nm = "${list.applicant_nm}";
		list.push(item);
	</c:forEach>
console.log(list);
	for(var i = 0; i < list.length; i++){
		var ahtml= "";
		ahtml +="<table class='tbl'>"
			ahtml +="<caption class='caption_hide'>특허리스트</caption>"
			ahtml +="<colgroup>"
			ahtml +="<col style='width:60%'/>"
			ahtml +="<col  />"
			ahtml +="<col  />"
			ahtml +="</colgroup>"
			ahtml +="<thead>"
			ahtml +="<tr>"
			ahtml +="<th>발명의 명칭</th>"
			ahtml +="<th>출원번호</th>"
			ahtml +="<th>출원인</th>"
			ahtml +="<tr>"
			ahtml +="</thead>"
			ahtml +="<tbody>"
			if(list[0].invent_nm != '' && list[0].invent_nm != 0){
				for(var i=0; i<list.length;i++){
					ahtml +="<tr>"
						ahtml +=	"<td class='ta_left'>"+list[i].invent_nm+"</td>"
						ahtml +=	"<td >"+list[i].applicant_no+"</td>"
						ahtml +=	"<td >"+list[i].applicant_nm+"</td>"
					ahtml +="<tr>"
				}
			}else{
				ahtml +=	"<td colspan='3'>국가 과제 수행 이력이 확인되지 않았습니다.</td>"
			}
		
	   ahtml +="</tbody>"
		ahtml +="</table>"
		$('#tbl3').empty();
    	$('#tbl3').append(ahtml);
	}
	
}

//특허리스트 줄이기 이벤트
function lessPatentContens(){

	var list = new Array();
	<c:forEach items="${patentData}" var="list">
		var item ={};
		item.invent_nm = "${list.invent_nm}";
		item.aplicat_no = "${list.aplicat_no}";
		item.aplicat_nm = "${list.aplicat_nm}";
		list.push(item);
	</c:forEach>
	
	for(var i = 0; i < 5; i++){
		console.log(list);
		var ahtml= "";
		ahtml +="<table class='tbl'>"
			ahtml +="<caption class='caption_hide'>특허리스트</caption>"
			ahtml +="<colgroup>"
			ahtml +="<col ' />"
			ahtml +="<col  />"
			ahtml +="<col  />"
			ahtml +="</colgroup>"
			ahtml +="<thead>"
			ahtml +="<tr>"
			ahtml +="<th>발명의 명칭</th>"
			ahtml +="<th>출원번호</th>"
			ahtml +="<th>출원인</th>"
			ahtml +="<tr>"
			ahtml +="</thead>"
			ahtml +="<tbody>"
			if(list[0].invent_nm != '' && list[0].invent_nm != 0){
				for(var i=0; i<5; i++){
					ahtml +="<tr>"
						ahtml +=	"<td class='ta_left'>"+list[i].invent_nm+"</td>"
						ahtml +=	"<td >"+list[i].applicant_no+"</td>"
						ahtml +=	"<td >"+list[i].applicant_nm+"</td>"
					ahtml +="<tr>"
				}
			}else{
				ahtml +=	"<td colspan='3'>국가 과제 수행 이력이 확인되지 않았습니다.</td>"
			}
		
	   ahtml +="</tbody>"
		ahtml +="</table>"
		$('#tbl3').empty();
    	$('#tbl3').append(ahtml);
	}
}

function techInquiry(){
	$.ajax({
        type : 'POST',
        url : '/techtalk/sendTechInquiry.do',
        data : $('#frm').serialize(),
        dataType : 'json',
        beforeSend: function() {
           $('.wrap-loading').css('display', 'block');
        },
        success : function() {
           alert("기술문의가 완료되었습니다.");
        },
        error : function() {
           
        },
        complete : function() {
           
        }
     });
}
</script>
<form id="frm" name="frm" action ="/techtalk/viewResearchDetail.do" method="post" >
<input type="hidden" id="research_no" name="research_no" value="${paraMap.research_no}">
<input type="hidden" id="research_seqno" name="research_seqno" value="${paraMap.research_seqno}">
</form>
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">연구자 상세정보</h3>
				<div class="right">
					<a href="javascript:window.history.back();" class="btn_back">뒤로가기</a>
				</div>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<div class="tbl_view tbl_public">
					<table class="tbl">
						<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);" >연구자 상세정보</caption>
						<colgroup>
							<col style="width: 10%">
							<col>
						</colgroup>
						<thead></thead>
						<tbody class="view">
							<tr>
								<th scope="col"><label for="re_nm">연구자</label></th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"> <c:out value="${data.researcher_nm }"  escapeXml="false"/> </div>
								</td>
								<th scope="" rowspan="3">연구자 소재 및 주요 연구분야</th>
								<td class="ta_left" rowspan="3">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.re_intro_field }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">기술분류</th>
								<td class="ta_left">${data.code_name1} > ${data.code_name2} > ${data.code_name3}</td>
							</tr>
							<tr>
								<th scope="col">키워드</th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.keyword }"  escapeXml="false"/> </div>
								</td>
								
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
				</div>
			</div>
			<div class="area_cont area_cont2">
				<div class="subject_corp">
					<h4>국가 과제 수행 이력</h4>
				</div>
				<div class="tbl_comm tbl_public">
					<table class="tbl" id="tbl2">
						<caption class="caption_hide">국가 과제 수행 이력</caption>
						<colgroup>
							<col>
							<col>
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>과제명</th>
								<th>과제관리기관</th>
								<th>연구기관</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
							<c:when test="${not empty proData[0].re_project_nm }">
							<c:forEach var="projectData" items="${proData}" end="4">
								<tr>
									<td class="ta_left">${projectData.re_project_nm}</td>
									<td>${projectData.re_institu_nm}</td>
									<td>${projectData.re_start_date} ~ ${projectData.re_end_date}</td>
								</tr>
							</c:forEach>
							</c:when>
							<c:otherwise>
								<td colspan="3">국가 과제 수행 이력이 확인되지 않았습니다.</td>
							</c:otherwise>
						</c:choose>
						</tbody>
					</table>
					<a href="javascript:void(0);" onclick="moreProContens();" id="moreProButton" title="더보기" class="btn-more">+ 더보기</a>
					<a href="javascript:void(0);" onclick="lessProContens();" id="lessProButton" title="줄이기" class="btn-more">- 줄이기</a>
				</div>
			</div>
			
			<div class="area_cont area_cont2">
				<div class="subject_corp">
					<h4>연구 히스토리</h4>
				</div>
				<div class="tbl_comm tbl_public history_tbl_wrap">
					<table class="tbl history_tbl" id="tbl2">
						<caption class="caption_hide">연구 히스토리</caption>
						<c:choose>
							<c:when test="${not empty dataHis[0].his_date}">
								<c:forEach var="listHis" items="${dataHis}">
									<colgroup>
										<col>
									</colgroup>
										<thead>
											<tr>
											<c:set var="his_date" value="${listHis.re_start_date}" />
												<th style="width: 100%;">${fn:substring(his_date,0,4)}</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>${listHis.keyword}</td>
											</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								등록된 연구 히스토리가 없습니다.
							</c:otherwise>
						</c:choose>
						</tbody>
					</table>
					</div>
			</div>
			
			<div class="area_cont area_cont2">
				<div class="subject_corp">
					<h4>유사분야 연구자</h4>
				</div>
				<div class="cont_list2">
					<div class="row col-box col3">
					<c:choose>
						<c:when test="${not empty similData }">
						<c:forEach var="similData" items="${similData}" end="2">
							<div class="col">
		                         <span class="row_txt_num blind">1</span>
		                         <span class="txt_left row_txt_tit">${ similData. research_nm } 연구자</span>
		                         <span class="re_beloong">${ similData. applicat_nm }</span>
		                         <ul class="tag_box">
		                             <li>${ similData. keyword }</li>
		                         </ul>
		                         <ul class="step_tech">
		                             <li><span class="mr txt_grey tech_nm ">${ similData. tech_nm1 }</span></li>
		                             <li><span class="mr txt_grey tech_nm ">${ similData. tech_nm2 }</span></li>
		                             <li><span class="mr txt_grey tech_nm ">${ similData. tech_nm3 }</span></li>
		                         </ul>
		                     </div>
						</c:forEach>
						</c:when>
						<c:otherwise>
							유사분야 연구자가 확인되지 않았습니다.
						</c:otherwise>
					</c:choose>
					</div>
				</div>
			</div>
			
			<div class="area_cont area_cont2">
				<div class="subject_corp">
					<h4>특허리스트</h4>
				</div>
				<div class="tbl_comm tbl_public">
					<table class="tbl" id="tbl3">
						<caption class="caption_hide">특허리스트</caption>
						<colgroup>
							<col style='width:60%'/>
							<col>
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>발명의 명칭</th>
								<th>출원번호</th>
								<th>출원인</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
							<c:when test="${not empty patentData[0].invent_nm }">
							<c:forEach var="patentData" items="${patentData}" end="4">
								<tr>
									<td class="ta_left">${patentData.invent_nm}</td>
									<td>${patentData.applicant_no}</td>
									<td>${patentData.applicant_nm} </td>
								</tr>
							</c:forEach>
							</c:when>
							<c:otherwise>
								<td colspan="3">국가 과제 수행 이력이 확인되지 않았습니다.</td>
							</c:otherwise>
						</c:choose>
						</tbody>
					</table>
					<a href="javascript:void(0);" onclick="morePatentContens();" id="morePatentButton" class="btn-more">+ 더보기</a>
					<a href="javascript:void(0);" onclick="lessPatentContens();" id="lessPatentButton"  class="btn-more">- 줄이기</a>
				</div>
				<div class="wrap_btn _center">
                    <a href="javascript:void(0);" onclick="techInquiry();" id="techInquiryButton" title="기술이전 문의하기" class="btn_appl">기술이전 문의하기</a>
                </div>
				
			</div>
			<c:if test="${sessionScope.member_type eq 'TLO'}">
				<div class="area_cont area_cont2">
					<div class="subject_corp">
						<h4>담당자 정보</h4>
					</div>
					<div class="tbl_view tbl_public">
						<table class="tbl">
							<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);" >담당자 정보</caption>
							<colgroup>
								<col style="width: 10%">
								<col>
							</colgroup>
							<thead></thead>
							<tbody class="view">
								<tr>
									<th scope="col"><label for="re_belong">소속</label></th>
									<td class="ta_left">
										<div class="form-control" style="max-width:100%;max-height:100%"> <c:out value="${data.manager_demand }"  escapeXml="false"/> </div>
									</td>
								</tr>
								<tr>
									<th scope="col">직책</th>
									<td class="ta_left">${data.manager_rank}</td>
								</tr>
								<tr>
									<th scope="col">이름</th>
									<td class="ta_left">${data.manager_name} </td>
								</tr>
								<tr>
									<th scope="col">연락처</th>
									<td class="ta_left">
										<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.manager_mobile_no }"  escapeXml="false"/> </div>
									</td>
								</tr>
								<tr>
									<th scope="col">이메일</th>
									<td class="ta_left">
										<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.manager_email }"  escapeXml="false"/> </div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</c:if>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>

