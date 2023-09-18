<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>

$(document).ready(function(){

});


//기술분야 분류 검색
$('#stdClassSrch').click(function() {
	var $href = $(this).attr('href');
	var op = $(this);
    layer_popup($href, op);
});



//연구자 상세보기 화면
function corporateDetail(corporate_no){
	var frm = document.createElement('form'); 

	frm.name = 'frm3'; 
	frm.method = 'post'; 
	frm.action = '/techtalk/viewCorprateDetail.do'; 

	var input1 = document.createElement('input'); 

	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "corporate_no"); 
	input1.setAttribute("value", corporate_no); 

	frm.appendChild(input1); 
	
	document.body.appendChild(frm); 
	frm.submit();
	
}
//기술수요 등록 팝업 페이지
function regist_popup() {
		var url = "/techtalk/registerCoTechDemand";
		var name = "popup test";
		var option = "width = 1080, height = 1000, top = 100, left = 200, location = no "
		window.open(url, name, option);
}
    
</script>

<form id="frm" name="frm" action ="/techtalk/doKeywordResult.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <!-- page_title s:  -->
            <div class="wrap_btn _center">
				<a href="javascript:regist_popup();" class="btn_confirm"title="등록">등록 </a>
			</div> 
            <div class="area_cont">
            	
            	<div class="subject_corp">
						<h3 class="tbl_ttc">
							기업수요 목록 
						</h3>
						<div class="belong_box">
			                <dl class="belong_box_inner">
			                    <dt>소속</dt>
			                    <dd>${data.biz_name}</dd>
			                </dl>
	            	</div>
				</div>			
					<!-- page_content s:  -->
					<div class="list_panel" id="tbl">
						<div class="cont_list">
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<div class="row">
											<span class="row_txt_num blind">${ data.corporate_no }</span>
											<span class="txt_left row_txt_tit"><a href="javascript:void(0);" onclick="corporateDetail('${data.corporate_no}')" title="기술명${data.tech_class_nm }상세보기">${ data.tech_class_nm }</a> </span>
											<span class="re_beloong">최근 업데이트 일자 : ${ data.co_update_dt }</span>
											<ul class="step_tech">
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm1 }</span></li>
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm2 }</span></li>
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm3 }</span></li>
												
											</ul>
											<ul class="tag_box">
			                                    <li>${ data.keyword }</li>
			                                </ul>
												
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td colspan="6">기술수요가 없습니다.</td>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				<!-- page_content s:  -->
					<div class="paging_comm">${ sPageInfo }</div>
				</div>
            
			</div>

		</div>
	</div>
</form>

<!-- //compaVcContent e:  -->

