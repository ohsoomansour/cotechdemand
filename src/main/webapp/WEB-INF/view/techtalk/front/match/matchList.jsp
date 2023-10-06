<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	
});

function historyClick(dem_seqno, research_seqno, match_number){
 	var url = "/techtalk/doMatchHistoryListX.do";
 	var form = $('#frm')[0];
	var data = new FormData(form);
	$.ajax({
		url : url,
       type: "post",
       data: {
    	   demand_seqno : dem_seqno,
    	   researcher_seqno : research_seqno
       	},
       dataType: "json",
       success : function(res){
    	   console.log(res.data[0]);
    	   console.log(res.data.length);
    	   if(res.data.length != 0 ){
    	   var ahtml= "";
    	   ahtml +="<table class='tbl'>"
    	   ahtml +="<caption class='caption_hide'>매칭리스트</caption>"
    	   ahtml +="<colgroup>"
   		   ahtml +="<col style='width:150px;'>"
   		   ahtml +="<col>"
		   ahtml +="<col style='width: 300px;'>"
		   ahtml +="<col style='width: 300px;'>"
		   ahtml +="</colgroup>"
		   ahtml +="<thead>"
		   ahtml +="<tr>"
		   ahtml +="<th scope='col'>일자</th>"
		   ahtml +="<th scope='col'>내용</th>"
		   ahtml +="<th scope='col'>기업수요 담당자</th>"
		   ahtml +="<th scope='col'>연구자 담당자</th>"
		   ahtml +="</tr>"
		   ahtml +="</thead>"
		   ahtml +="<tbody>"
			for(var i=0; i<res.data.length; i++){
				ahtml +="<tr>"
			   ahtml +="<td>"+res.data[i].match_date+"</td>"
			   ahtml +="<td class='ta_left'>"+res.data[i].contents+"</td>"
			   ahtml +="<td>"+res.data[i].business_nm+" / "+res.data[i].business_tel+" / "+res.data[i].business_email+"</td>"
			   ahtml +="<td>"+res.data[i].researcher_nm+" / "+res.data[i].researcher_tel+" / "+res.data[i].researcher_email+"</td>"
			   ahtml +="</tr>"
			}
		   ahtml +="</tbody>"
		   ahtml +="</table>"
		   $('#match_number_'+match_number).empty();
		   $('#match_number_'+match_number).append(ahtml);
//		   $('.tbl_public').empty();
//		   $('.tbl_public').append(ahtml);
    	   }else if(res.data.length == 0 ){
    		   var ahtml= "";
        	   ahtml +="<table class='tbl'>"
        	   ahtml +="<caption class='caption_hide'>매칭리스트</caption>"
        	   ahtml +="<colgroup>"
       		   ahtml +="<col style='width:150px;'>"
       		   ahtml +="<col>"
    		   ahtml +="<col style='width: 300px;'>"
    		   ahtml +="<col style='width: 300px;'>"
    		   ahtml +="</colgroup>"
    		   ahtml +="<thead>"
    		   ahtml +="<tr>"
    		   ahtml +="<th scope='col'>일자</th>"
    		   ahtml +="<th scope='col'>내용</th>"
    		   ahtml +="<th scope='col'>기업수요 담당자</th>"
    		   ahtml +="<th scope='col'>연구자 담당자</th>"
    		   ahtml +="</tr>"
    		   ahtml +="</thead>"
    		   ahtml +="<tbody>"
    				ahtml +="<tr>"
    			   ahtml +="<td colspan ='4'>매칭이력이 없습니다</td>"
    			   ahtml +="</tr>"
    		   ahtml +="</tbody>"
    		   ahtml +="</table>"
    		   $('#match_number_'+match_number).empty();
    		   $('#match_number_'+match_number).append(ahtml);
//    		   $('.tbl_public').empty();
//    		   $('.tbl_public').append(ahtml);
        	}
       },
       error : function(){
    	alert('실패했습니다.');    
       },
       async:false,
       complete : function(){

       }
	});
}

function techInquiry(biz_name){
	$.ajax({
        type : 'POST',
        url : '/techtalk/sendInquiryMatchX.do',
        data :  {
        	biz_name : biz_name
       },
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
<form action="/techtalk/doMatchHistoryList.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="match_seqno" name="match_seqno" value=""/>
</form>

<form action="#" id="frm" name="frm" method="get">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="rows" id="rows" value="${paraMap.rows}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
								
			<div class="area_cont">
				<c:choose>
					<c:when test="${sessionScope.member_type eq 'R'}">
							<div class="area_tit">
								<h3 class="tit_corp">매칭된 기업수요 목록</h3>
								<div class="belong_box">
					                <dl class="belong_box_inner">
					                    <dt>소속</dt>
					                    <dd>${dataR[0].biz_name}</dd>
					                </dl>
					            </div>
							</div>
							<div class="list_panel">
			                    <div class="cont_list">
			                    <c:choose>
			                    	<c:when test="${ not empty dataR }">
			                    		<c:forEach var="dataR" items="${ dataR }">
			                    			<div class="row col-box">
			                    				<div class="col">
			                    					<span class="row_txt_num blind">${ dataR.length }</span>
			                    					<span class="txt_left row_txt_tit">${ dataR.researcher_nm} 연구자 </span>
					                                <span class="re_beloong">${dataR.applicant_nm }</span>
					                                <ul class="tag_box">
						                                <c:set var="originalString" value="${dataR.rkwd}" />
														<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
														<c:forEach var="item" items="${splitArray}">
														    <li>#<c:out value="${item}" /></li>
														</c:forEach>
					                                </ul>
					                                <ul class="step_tech">
					                                    <li><span class="mr txt_grey tech_nm ">${ dataR.rcode_name1}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataR.rcode_name2}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataR.rcode_name3}</span></li>
					                                </ul>
			                    				</div>
			                    				 <span class="arrow"></span>
					                            <div class="col">
					                                <span class="row_txt_num blind">1</span>
					                                <span class="txt_left row_txt_tit txt_line txt_ellip ">${ dataR.tech_nm}</span>
					                                <span class="update_date">최근 업데이트 일자 : ${ dataR.rupdate}</span>
					                                <ul class="tag_box">
					                                    <c:set var="originalString" value="${dataR.bkwd}" />
														<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
														<c:forEach var="item" items="${splitArray}">
														    <li>#<c:out value="${item}" /></li>
														</c:forEach>
					                                </ul>
					                                <ul class="step_tech">
					                                    <li><span class="mr txt_grey tech_nm ">${ dataR.bcode_name1}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataR.bcode_name2}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataR.bcode_name3}</span></li>
					                                </ul>
					                            </div>
					                            <button type="button" class="email_btn ">
					                            	<a href="javascript:void(0);" onclick="techInquiry('${dataR.rbiz_name}');" title="문의하기" class="btn_appl">
					                            		<span>문의하기</span
					                            	></a>
					                            </button>
			                    			</div>
			                    		</c:forEach>
				                           
			                    	</c:when>
			                    	<c:otherwise>
				                        <div class="row">
				                            <div class="empty_data">
				                                <p>아직 매칭된 기업수요가 없습니다.</p>
				                            </div>
				                        </div>
			                    	</c:otherwise>
			                    </c:choose>
							</div>
						</div>
					</c:when>
					<c:when test="${sessionScope.member_type eq 'B'}">
							<div class="area_tit">
								<h3 class="tit_corp">매칭된 연구자 목록</h3>
								<div class="belong_box">
					                <dl class="belong_box_inner">
					                    <dt>소속</dt>
					                    <dd>${dataB[0].biz_name}</dd>
					                </dl>
					            </div>
							</div>
							<div class="list_panel">
			                    <div class="cont_list">
			                    <c:choose>
			                    	<c:when test="${ not empty dataB }">
			                    		<c:forEach var="dataB" items="${ dataB }">
			                    			<div class="row col-box">
					                            <div class="col">
					                                <span class="row_txt_num blind">${ dataB.length }</span>
					                                <span class="txt_left row_txt_tit txt_line txt_ellip ">${ dataB.tech_nm}</span>
					                                <span class="update_date">최근 업데이트 일자 : ${ dataB.rupdate}</span>
					                                <ul class="tag_box">
					                                    <c:set var="originalString" value="${dataB.bkwd}" />
														<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
														<c:forEach var="item" items="${splitArray}">
														    <li>#<c:out value="${item}" /></li>
														</c:forEach>
					                                </ul>
					                                <ul class="step_tech">
					                                    <li><span class="mr txt_grey tech_nm ">${ dataB.bcode_name1}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataB.bcode_name2}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataB.bcode_name3}</span></li>
					                                </ul>
					                            </div>
					                            <span class="arrow"></span>
					                            <div class="col">
			                    					<span class="row_txt_num blind">${ dataB.length }</span>
			                    					<span class="txt_left row_txt_tit">${ dataB.researcher_nm} 연구자 </span>
					                                <span class="re_beloong">${dataB.applicant_nm }</span>
					                                <ul class="tag_box">
						                                <c:set var="originalString" value="${dataB.rkwd}" />
														<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
														<c:forEach var="item" items="${splitArray}">
														    <li>#<c:out value="${item}" /></li>
														</c:forEach>
					                                </ul>
					                                <ul class="step_tech">
					                                    <li><span class="mr txt_grey tech_nm ">${ dataB.rcode_name1}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataB.rcode_name2}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataB.rcode_name3}</span></li>
					                                </ul>
			                    				</div>
					                            <button type="button" class="email_btn ">
					                            	<a href="javascript:void(0);" onclick="techInquiry('${dataB.bbiz_name}');" title="문의하기" class="btn_appl">
					                            		<span>문의하기</span
					                            	></a>
					                            </button>
			                    			</div>
			                    		</c:forEach>
				                           
			                    	</c:when>
			                    	<c:otherwise>
				                        <div class="row">
				                            <div class="empty_data">
				                                <p>아직 매칭된 연구자가 없습니다.</p>
				                            </div>
				                        </div>
			                    	</c:otherwise>
			                    </c:choose>
							</div>
						</div>
					</c:when>
					<c:when test="${sessionScope.member_type eq 'TLO'}">
							<div class="area_tit">
								<h3 class="tit_corp">매칭된 연구자-기업수요 목록</h3>
								<div class="belong_box">
					                <dl class="belong_box_inner">
					                    <dt>소속</dt>
					                    <dd>${dataTLO[0].biz_name}</dd>
					                </dl>
					            </div>
							</div>
							<div class="list_panel">
			                    <div class="cont_list">
			                    <c:choose>
			                    	<c:when test="${ not empty dataTLO }">
			                    		<c:forEach var="dataTLO" items="${ dataTLO }">
			                    			<div class="row col-box">
					                            <div class="col">
					                                <span class="row_txt_num blind">${ dataTLO.length }</span>
					                                <span class="txt_left row_txt_tit txt_line txt_ellip ">${ dataTLO.tech_nm}</span>
					                                <span class="update_date">최근 업데이트 일자 : ${ dataTLO.rupdate}</span>
					                                <ul class="tag_box">
					                                    <c:set var="originalString" value="${dataTLO.bkwd}" />
														<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
														<c:forEach var="item" items="${splitArray}">
														    <li>#<c:out value="${item}" /></li>
														</c:forEach>
					                                </ul>
					                                <ul class="step_tech">
					                                    <li><span class="mr txt_grey tech_nm ">${ dataTLO.bcode_name1}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataTLO.bcode_name2}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataTLO.bcode_name3}</span></li>
					                                </ul>
					                            </div>
					                            <span class="arrow"></span>
					                            <div class="col">
			                    					<span class="row_txt_num blind">${ dataTLO.length }</span>
			                    					<span class="txt_left row_txt_tit">${ dataTLO.researcher_nm} 연구자 </span>
					                                <span class="re_beloong">${dataTLO.applicant_nm }</span>
					                                <ul class="tag_box">
						                                <c:set var="originalString" value="${dataTLO.rkwd}" />
														<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
														<c:forEach var="item" items="${splitArray}">
														    <li>#<c:out value="${item}" /></li>
														</c:forEach>
					                                </ul>
					                                <ul class="step_tech">
					                                    <li><span class="mr txt_grey tech_nm ">${ dataTLO.rcode_name1}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataTLO.rcode_name2}</span></li>
					                                    <li><span class="mr txt_grey tech_nm ">${ dataTLO.rcode_name3}</span></li>
					                                </ul>
			                    				</div>
					                            <button type="button" class="history_btn" ><span><a href="javascript:void(0);" onclick="historyClick('${ dataTLO.dem_seqno}','${ dataTLO.research_seqno}','${ dataTLO.match_number}')">이력보기</a></span></button>
			                    			</div>
			                    			<div class="tbl_public" id="match_number_${ dataTLO.match_number }">
			                    			</div>
			                    		</c:forEach>
				                           
			                    	</c:when>
			                    	<c:otherwise>
				                        <div class="row">
				                            <div class="empty_data">
				                                <p>아직 매칭된 연구자-기업수요가 없습니다.</p>
				                            </div>
				                        </div>
			                    	</c:otherwise>
			                    </c:choose>
			                    
							</div>
						</div>
					</c:when>
				</c:choose>
				</div>
			</div>
		</div>
	</div>
</form>