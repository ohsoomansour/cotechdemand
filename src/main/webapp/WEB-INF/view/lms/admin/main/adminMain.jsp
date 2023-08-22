<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
var pwTempFlag = '${userInfo.pw_temp_flag}';

$(document).ready(function(){
	if(pwTempFlag == 'Y') {
		if(confirm('현재 임시비밀번호로 저장되어있습니다. 비밀번호를 변경하시겠습니까?')) {
			var url = '/front/updatePwForm.do';
			openDialog({
		        title:"임시비밀번호 변경",
		        width:520,
		        height:350,
		        url: url
		 	});
		}
	}
});
function doPerform(subject_seqno){
	$('#subject_seqno').val(subject_seqno);
	$('#detail').submit();
}
</script>

<div class="contents">
  <div class="content_wrap">
    <a href="/front/listFrontSurveyPaper.do" class="btn btn-primary btn-sm">설문조사</a>
    <a href="/front/listBoardItem.do?board_seq=100" class="btn btn-primary btn-sm">공지사항</a>
    <a href="/front/mainView.do" class="btn btn-primary btn-sm">배너관리 &amp; 팝업관리</a>
    
    <h2>사용자</h2><br/>
    <a href="/project/list.do" class="btn btn-primary btn-sm">사업공고리스트</a>
    <a href="/project/detail.do?seqNo=18" class="btn btn-primary btn-sm">사업공고상세보기</a>
    <a href="/subject/apply.do?seqNo=18&status_apply=reg" class="btn btn-primary btn-sm">사업신청서 작성</a>
    <a href="/subject/applyFin.do?status=save" class="btn btn-primary btn-sm">사업공고 등록,수정 완료</a>
    <!-- <a href="/subject/applyStatusList.do" class="btn btn-primary btn-sm">사업신청 현황</a> -->
    <a href="/subject/list.do" class="btn btn-primary btn-sm">사업신청 현황</a>
    <!-- <a href="/subject/applyPerformance.do" class="btn btn-primary btn-sm">사업수행</a> -->
    <form action = "/subject/applyPerformance.do" id="detail" method="post" >
    	<input type="hidden" id="subject_seqno" name="subject_seqno"  value=""/>
    		<a href="#" class="btn btn-primary btn-sm" onclick="doPerform('128')">사업수행 상세보기</a>
			<!-- <button type="submit"  >사업수업상세보기 </button> -->
		</form><br/>
    <a href="/projectapply/applyPayment.do" class="btn btn-primary btn-sm">사업비청구</a>
    
    <br /><br />
    
    <a href="/front/memberJoinPage.do" class="btn btn-primary btn-sm">수요기업/공급기업 회원가입</a>
    <a href="/front/memberPrivacyPage.do" class="btn btn-primary btn-sm">수요기업/공급기업 개인정보관리</a>
    
    <div style="display: block">
	    <h1 class="page-header">사용자 관리</h1>
		<!-- pathIndicator -->
		<p class="pathIndicator">
			<span class="home"><span class="glyphicon glyphicon-home"></span></span>
			<span class="separator">&gt;</span>
			<span class="category">메뉴이름1</span>
			<span class="separator">&gt;</span>
			<span class="current category">메뉴이름2</span>
		</p>
		<!-- //pathIndicator -->
		
			<div class="clearFix lh30 mTop30">
				<h2 class="fL contentTit2">서브 타이틀</h2>
				<p class="fR"><button type="button" class="btn btn-primary btn-sm">저장</button></p>
			</div>
			<!-- 검색 -->
			<div class="searchTextBox well type1 mTop20">
				<div class="line form-inline alignCenter">
					<input type="text" class="form-control" size="40" placeholder="검색어를 입력하세요."> <input type="submit" class="btn btn-primary btn-sm" value="검색">
				</div>
			</div>
			<!-- 검색 -->
			<div class="searchDetail" id="searchDetail">
				<div class="well mTop10">
					<table class="table1">
						<colgroup>
							<col style="width:80px">
							<col>
							<col style="width:80px">
							<col>
						</colgroup>
						<tbody><tr>
							<th>공개여부</th>
							<td>
								<label class="spanBox"><input type="checkbox"> 전체</label>
								<label class="spanBox"><input type="checkbox"> 공개</label>
								<label class="spanBox"><input type="checkbox"> 부분공개</label>
								<label class="spanBox"><input type="checkbox"> 비공개</label>
							</td>
							<th>결재권자</th>
							<td>
								<label class="spanBox"><input type="checkbox"> 전체</label>
								<label class="spanBox"><input type="checkbox"> 기관장</label>
								<label class="spanBox"><input type="checkbox"> 국장</label>
							</td>
						</tr>
						<tr>
							<th>생산부서</th>
							<td class="form-inline">
								<input type="text" class="form-control"> <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#pop-department">부서</button>
							</td>
							<th>결과정렬</th>
							<td>
								<label class="spanBox"><input type="radio"> 문서번호</label>
								<label class="spanBox"><input type="radio"> 생산일자</label>
								<label class="spanBox"><input type="radio"> 문서제목</label>
								<label class="spanBox"><input type="radio"> 기안자</label>
							</td>
						</tr>
						<tr>
							<th>기간설정</th>
							<td colspan="3" class="form-inline btns">
								<button type="button" class="btn btn-default btn-sm">1주일</button>
								<button type="button" class="btn btn-default btn-sm">1개월</button>
								<button type="button" class="btn btn-default btn-sm">3개월</button>
								<input type="text" class="form-control datepicker"> ~ <input type="text" class="form-control datepicker">
							</td>
						</tr>
					</tbody></table>
					<div class="btnWrap alignRight mTop10">
						<input type="submit" class="btn btn-primary btn-sm" value="검색">
						<input type="reset" class="btn btn-default btn-sm" value="초기화">
					</div>
				</div>
			</div>
			<!-- 검색 -->
			<!-- 테이블상단 옵션 -->
			<div class="clearFix mTop20">
				<div class="btn-group fL" data-toggle="buttons">
					<label class="btn btn-default btn-sm active width80">
						<input type="radio" name="options" id="option1" autocomplete="off" checked=""> 기간별
					</label>
					<label class="btn btn-default btn-sm width80">
						<input type="radio" name="options" id="option2" autocomplete="off"> 조직별
					</label>
					<label class="btn btn-default btn-sm width80">
						<input type="radio" name="options" id="option3" autocomplete="off"> 개인별
					</label>
				</div>
				<div class="fL mLeft20 form-inline">
					<select class="form-control">
						<option>2019년</option>
					</select>
					<select class="form-control">
						<option>10월</option>
					</select>
					<input type="submit" class="btn btn-primary btn-sm" value="검색">
				</div>
				<div class="fR">
					<a href="#" class="btn btn-default btn-sm"><i class="fa fa-file-excel-o"></i> 엑셀 다운로드</a>
				</div>
			</div>
			<!-- 테이블상단 옵션 -->
			<!-- table -->
			<div class="table2 mTop20">
				<table>
					<colgroup>
						<col style="width:10%" />
						<col style="width:40%" />
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody class="line">
						<tr>
							<th>최종 변경일</th>
							<td class="left">2019.06.10</td>
							<th>변경 변경일</th>
							<td class="left">2019.09.10</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //table -->
		
			<!-- table -->
			<div class="table2 mTop10">
				<table>
					<colgroup>
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody class="line">
						<tr>
							<th>이전비밀번호</th>
							<td class="left form-group">
								<input type="password" class="form-control" />
							</td>
						</tr>
						<tr>
							<th>신규비밀번호</th>
							<td class="left form-group">
								<input type="password" class="form-control" />
							</td>
						</tr>
						<tr>
							<th>비밀번호확인</th>
							<td class="left form-group">
								<input type="password" class="form-control" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //table -->
			<!-- 리스트스타일 -->
			<ul class="mTop10 textList">
				<li>시스템 보안을 위하여, 비밀번호는 주기적으로 변경해 주시는 것이 좋습니다.</li>
				<li>최소 8자의 영문 대소문자, 숫자, 특수문자를 조합하여 사용하실 수 있습니다.</li>
				<li>이메일, 아이디, 전화번호 등 개인정보와 관련된 숫자, 연속된 숫자와 같이 쉬운 비밀번호는 다른 사람이 쉽게 알아낼 수 있으니 사용을 자제해 주세요.</li>
				<li>이전에 사용했던 비밀번호와는 다른 비밀번호를 사용하여 주십시오.</li>
			</ul>
		    <!-- 버튼 오른쪽 -->
		    <div class="btnList alignRight mTop30">
				<button type="button" class="btn btn-primary btn-sm">버튼스타일1</button>
				<button type="button" class="btn btn-default btn-sm">버튼스타일2</button>
			</div>
			<!-- 버튼 왼쪽 -->
			<div class="btnList alignLeft mTop30">
				<button type="button" class="btn btn-primary btn-sm">버튼스타일1</button>
				<button type="button" class="btn btn-default btn-sm">버튼스타일2</button>
			</div>
		</div>
	</div>
</div>