<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>

	$(document).ready(function(){

	});
	
	
</script>
<!-- compaVcContent s:  -->
<form action="/techtalk/memberJoinFormPage.do" id="frm2" name="frm2" method="get">
</form>
<form action="#" id="frm" name="frm" method="post">
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">연구자 목록</h3>
                <div class="belong_box">
	                <dl class="belong_box_inner">
	                    <dt>소속</dt>
	                    <dd>대구경북과학기술원</dd>
	                </dl>
	            </div>
			</div>
			
			
			<div class="area_cont">
				<div class="list_panel" id="tbl">
					<div class="cont_list">
						<div class="list_top">
							<p>count : 00건</p>
							<div class="list_top_util ">
								<div class="search_box_inner">
									<div class="btn_box">
										<button type="button" class="btn_default" title="필터">
											<i class="icon_filter"></i>
											<span>필터</span>
										</button>
									</div>
									<div class="search_keyword_box">
										<input type="text" class="keyword_input" id="keyword" name="keyword" onkeypress="enterKeyClick(event)" placeholder="키워드를 입력하세요." value="" title="검색어">
									</div>
									<div class="btn_wrap">
										<button type="button" class="btn_step" onclick="javascript:keywordClick();" title="검색">
											<span>검색</span>
										</button>
									</div>
									<div class="btn_box btn_box2">
										<button type="button" class="btn_default" title="목록관리">
											<span>목록관리</span>
										</button>
										<button type="button" class="btn_point" title="저장">
											<span>저장</span>
										</button>
										<button type="button" class="btn_default" title="취소">
											<span>취소</span>
										</button>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<span class="box_checkinp">
			            		<input type="checkbox" class="inp_check" name="checkbox" id="37986" title="37986">
			                </span>
							<span class="row_txt_num blind">37986</span>
							<span class="txt_left row_txt_tit"><a href="javascript:void(0);" onclick="researchDetail('37986', '')" title="연구자오민석상세보기">오민석 연구자</a> </span>
							<span class="update_date">최근 업데이트 일자 : 2023.07.26</span>
							<ul class="step_tech">
								<li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
								<li><span class="mr txt_grey tech_nm ">선박</span></li>
								<li><span class="mr txt_grey tech_nm ">소재</span></li>
							</ul>
							<ul class="tag_box">
                                   <li></li>
                            </ul>
						</div>
						<div class="row">
							<span class="box_checkinp">
			            		<input type="checkbox" class="inp_check" name="checkbox" id="37986" title="37986">
			                </span>
							<span class="row_txt_num blind">37986</span>
							<span class="txt_left row_txt_tit"><a href="javascript:void(0);" onclick="researchDetail('37986', '')" title="연구자오민석상세보기">오민석 연구자</a> </span>
							<span class="update_date">최근 업데이트 일자 : 2023.07.26</span>
							<ul class="step_tech">
								<li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
								<li><span class="mr txt_grey tech_nm ">선박</span></li>
								<li><span class="mr txt_grey tech_nm ">소재</span></li>
							</ul>
							<ul class="tag_box">
                                   <li></li>
                            </ul>
						</div>
					</div>
				</div>
           	</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</form>
<!-- //compaVcContent e:  -->