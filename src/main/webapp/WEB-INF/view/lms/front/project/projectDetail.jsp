<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
var isShowGnb = false;
$window = $(window);
    $(document).ready(function() {
        $window.on('mousewheel', toggleGnb);
        toggleGnb();
    });

    function toggleGnb(e){
        if($('body').css('overflow') == 'hidden') return;
        if(!(e && $(e.target).is('textarea'))) {
            // var top = $window.scrollTop();
            var top = getCurrentScroll();
            var delta = e ? e.originalEvent.wheelDelta || -e.originalEvent.deltaY || -e.originalEvent.detail : -top;

            if (delta >= 2 || delta <= -2) {
                if (delta < 0 && top > 1) {
                    if (!isShowGnb) {
                        isShowGnb = true;
                        $("#compaVcHead").addClass('hide-gnb');
                    }
                } else {
                    if (isShowGnb) {
                        isShowGnb = false;
                        $("#compaVcHead").removeClass('hide-gnb');
                    }
                }
            }
        }
    }

    function getCurrentScroll() {
        return $window.scrollTop();
    }

    function doSubjectDetail(project_seqno){
		$('#project_seqno2').val(project_seqno);
		$('#frm2').submit();
	}
</script>
<form action="/subject/apply.do" id="frm2" name="frm2" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno2" value="" />
</form>
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">사업공고 상세정보</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<div class="tbl_view tbl_public">
					<table class="tbl">
						<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);" >사업공고 상세정보</caption>
						<colgroup>
							<col style="width: 10%">
							<col>
						</colgroup>
						<thead></thead>
						<tbody class="view">
							<tr>
								<th scope="col"><label for="project_title">사업명</label></th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"> <c:out value="${paraMap.project_title }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th scope="col">접수기간</th>
								<td class="ta_left">${paraMap.project_apply_sdate }~${paraMap.project_apply_edate }</td>
							</tr>
							<tr>
								<th scope="">사업개요</th>
								<td class="ta_left">
									<div class="form-control" style="max-width:100%;max-height:100%"> <c:out value="${paraMap.project_desc }"  escapeXml="false"/> </div>
								</td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
					<div class="tbl_comm tbl_public" style="margin-top:30px;">
						<table class="tbl ">
							<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">사업공고 첨부서류</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col style="width: 100px;"/>
								<col style="width: 280px;" />
								<col style="width: 100px;" />
								<col style="width: 150px;" />
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">파일구분</th>
									<th scope="col">첨부파일명</th>
									<th scope="col">파일크기(KB)</th>
									<th scope="col">필수여부</th>
									<th scope="col">다운로드</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="list" items="${fileList}" varStatus="status">
									<tr>
										<td>${status.count}</td>
										<td class="ta_center">
											<c:if test="${list.f_type eq 'BA' }">
												사업신청서
											</c:if> 
											<c:if test="${list.f_type eq 'MA'  }">
											매칭신청서
											</c:if> 
											<c:if test="${list.f_type eq 'CC'  }">
											기업확인서
											</c:if> 
											<c:if test="${list.f_type eq 'ETC'  }">
											기타
											</c:if>
										</td>
										<td class="ta_center">${list.f_org_nm}</td>
										<td>${list.trans_size }</td>
										<td>필수</td>
										<td>
											<a class="btn_step" href="/file/download.do?fmst_seq=${list.fmst_seq }&fslv_seq=${list.fslv_seq}">
											다운로드
											<span class="icon ico_down"></span>
											</a>
										</td>
									</tr>
								</c:forEach>
								<c:if test="${empty fileList}">
									<tr>
										<td colspan="6">첨부서류가 없습니다.</td>
									</tr>
								</c:if>
							</tbody>
							<tfoot></tfoot>
						</table>
					</div>
					<div class="wrap_btn">
						<c:if test="${! empty fileList }">
						<a href="/file/zipDownload.do?fmst_seq=${fmst_seq}" class="btn_step">
						첨부파일양식 일괄 다운로드 
							<span class="icon ico_down"></span>
						</a>
						</c:if>
					</div>
				</div>
				<div class="wrap_btn _center">
					<a href="/project/list.do" class="btn_list">목록으로 이동</a> 
						<c:if test="${ paraMap.project_proc_status eq 20 and paraMap.edate_chk eq 'N' and paraMap.sdate_chk eq 'N'}">
							<!-- <a href="#" class="btn_appl" onclick="bizNoClick();return false">사업 신청서 제출 </a> -->
 							<a href="javascript:void(0);" class="btn_appl" onclick="doSubjectDetail('${paraMap.project_seqno}' );">사업 신청서 제출 </a>
						</c:if>
					<%-- <a href="/subject/apply.do?seqNo=${paraMap.project_seqno}" class="btn_appl">사업 신청서 제출 </a> --%>
				</div>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>

