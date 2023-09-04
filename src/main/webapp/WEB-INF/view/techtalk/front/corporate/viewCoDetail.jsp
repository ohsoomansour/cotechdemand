<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function() {
	

});

</script>
<form id="frm" name="frm" action ="/techtalk/viewResearchDetail.do" method="post" >
<input type="hidden" id="tech_class_nm" name="tech_class_nm" value="${paraMap.tech_class_nm}">
<input type="hidden" id="corporate_no" name="corporate_no" value="${paraMap.corporate_no}">
</form>
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">기업수요 상세정보</h3>
			</div>
			<a href="javascript:window.history.back();">뒤로가기</a>
			<h5>최근 업데이트 일자</h5> <c:out value="${data.co_update_dt }"  escapeXml="false"/>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<div class="tbl_view tbl_public">
					<table class="tbl">
						<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);" >기업수요 상세정보</caption>
						<colgroup>
							<col style="width: 10%">
							<col>
						</colgroup>
						<thead></thead>
						<tbody class="view">
							<tr>
								<th scope="col"><label for="re_nm">기술명</label></th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"> <c:out value="${data.tech_class_nm }"  escapeXml="false"/> </div>
								</td>
								<th scope="" rowspan="3">필수기술</th>
								<td class="ta_left" rowspan="3">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.requir_skill }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">기술분류</th>
								<td class="ta_left">${data.tech_nm1} > ${data.tech_nm2} > ${data.tech_nm3}</td>
							</tr>
							<tr>
								<th scope="col">키워드</th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.keyword }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">기업 애로사항</th>
								<td class="ta_left" colspan="3">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.corporate_proble }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">보유 연구 인프라</th>
								<td class="ta_left" colspan="3">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.research_infra }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">투자의지(사업 투자 여력)</th>
								<td class="ta_left" colspan="3">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.invest }"  escapeXml="false"/> </div>
								</td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
				</div>
			</div>
			
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
									<div class="form-control" style="max-width:100%;max-height:100%"> <c:out value="${data.co_belong }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">직책</th>
								<td class="ta_left">${data.co_position}</td>
							</tr>
							<tr>
								<th scope="col">이름</th>
								<td class="ta_left">${data.co_nm} </td>
							</tr>
							<tr>
								<th scope="col">연락처</th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.co_tel }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">이메일</th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.co_email }"  escapeXml="false"/> </div>
								</td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
				</div>
			</div>
			
			
			<!-- //page_content e:  -->
		</div>
	</div>
</div>

