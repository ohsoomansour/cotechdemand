<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	

});

</script>
<form action="#" id="frm" name="frm" method="get">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="rows" id="rows" value="${paraMap.rows}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
	<h2 class="screen_out">본문영역</h2>
	<div class="wrap_cont">
		<div class="area_tit">
			<h3 class="tit_corp">매칭된 기업수요 목록</h3>
			<div class="belong_box">
                <dl class="belong_box_inner">
                    <dt>소속</dt>
                    <dd>대구경북과학기술원</dd>
                </dl>
            </div>
		</div>
							
			<div class="area_cont">
				<!-- 매칭된 기업수요 목록 //start -->
				<div class="list_panel">
                    <div class="cont_list">
                    	<!-- list -->
                        <div class="row col-box">
                            <div class="col">
                                <span class="row_txt_num blind">1</span>
                                <span class="txt_left row_txt_tit"><a href="javascript:void(0);"  title="연구자 상세보기">손준우 연구자</a> </span>
                                <span class="re_beloong">대국경북과학기술원</span>
                                <ul class="tag_box">
                                    <li>#자율주행</li>
                                    <li>#고령운전자</li>
                                    <li>#안전</li>
                                </ul>
                                <ul class="step_tech">
                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
                                </ul>
                            </div>
                            <span class="arrow"></span>
                            <div class="col">
                                <span class="row_txt_num blind">1</span>
                                <span class="txt_left row_txt_tit txt_line txt_ellip "><!-- 말줄임표 없애는 스타일 txt_ellip 클래스 제거 --><a href="javascript:void(0);"  title="기술 상세보기">자율주행 ADAS 센서자율주행 ADAS 센서자율주행자율주행 ADAS 센서자율주행 ADAS 센서 ADAS 센서</a> </span>
                                <span class="update_date">최근 업데이트 일자 : 2023.07.26</span>
                                <ul class="tag_box">
                                    <li>#자율주행</li>
                                    <li>#고령운전자</li>
                                    <li>#안전</li>
                                </ul>
                                <ul class="step_tech">
                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
                                </ul>
                            </div>
                            <button type="button" class="email_btn "><span>문의하기</span></button>
                        </div>
                        <!-- list -->
                        <!-- 데이터 없을때 -->
                        <div class="row">
                            <div class="empty_data">
                                <p>아직 매칭된 기업수요가 없습니다.</p>
                            </div>
                        </div>
	                  </div>
	              </div>
	              <!-- 매칭된 기업수요 목록 //end -->
	              
	            <!-- 매칭된 연구자 목록 //start -->
				<div class="list_panel">
                    <div class="cont_list">
                    	<!-- list -->
                        <div class="row col-box">
                            <div class="col">
                                <span class="row_txt_num blind">1</span>
                                <span class="txt_left row_txt_tit txt_line txt_ellip "><!-- 말줄임표 없애는 스타일 txt_ellip 클래스 제거 --><a href="javascript:void(0);"  title="기술 상세보기">자율주행 ADAS 센서자율주행 ADAS 센서자율주행자율주행 ADAS 센서자율주행 ADAS 센서 ADAS 센서</a> </span>
                                <span class="update_date">최근 업데이트 일자 : 2023.07.26</span>
                                <ul class="tag_box">
                                    <li>#자율주행</li>
                                    <li>#고령운전자</li>
                                    <li>#안전</li>
                                </ul>
                                <ul class="step_tech">
                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
                                </ul>
                            </div>
                            <span class="arrow"></span>
                           
                            <div class="col">
                                <span class="row_txt_num blind">1</span>
                                <span class="txt_left row_txt_tit"><a href="javascript:void(0);"  title="연구자 상세보기">손준우 연구자</a> </span>
                                <span class="re_beloong">대국경북과학기술원</span>
                                <ul class="tag_box">
                                    <li>#자율주행</li>
                                    <li>#고령운전자</li>
                                    <li>#안전</li>
                                </ul>
                                <ul class="step_tech">
                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
                                </ul>
                            </div>
                            <button type="button" class="email_btn "><span>문의하기</span></button>
                        </div>
                        <!-- list -->
                        
                        <!-- 데이터 없을때 -->
                        <div class="row">
                            <div class="empty_data">
                                <p>아직 매칭된 연구자가 없습니다.</p>
                            </div>
                        </div>
	                  </div>
	              </div>
	              <!-- 매칭된 연구자 목록 //end -->
	              
	              
	              <!-- 매칭된 연구자-기술수요 목록 //start -->
					<div class="list_panel">
	                    <div class="cont_list">
	                        <!-- list -->
	                        <div class="row col-box">
	                            <div class="col">
	                                <span class="row_txt_num blind">1</span>
	                                <span class="txt_left row_txt_tit txt_line txt_ellip "><!-- 말줄임표 없애는 스타일 txt_ellip 클래스 제거 --><a href="javascript:void(0);"  title="기술 상세보기">자율주행 ADAS 센서자율주행 ADAS 센서자율주행자율주행 ADAS 센서자율주행 ADAS 센서 ADAS 센서</a> </span>
	                                <span class="update_date">최근 업데이트 일자 : 2023.07.26</span>
	                                <ul class="tag_box">
	                                    <li>#자율주행</li>
	                                    <li>#고령운전자</li>
	                                    <li>#안전</li>
	                                </ul>
	                                <ul class="step_tech">
	                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
	                                </ul>
	                            </div>
	                            <span class="arrow"></span>
	                           
	                            <div class="col">
	                                <span class="row_txt_num blind">2</span>
	                                <span class="txt_left row_txt_tit"><a href="javascript:void(0);"  title="연구자 상세보기">손준우 연구자</a> </span>
	                                <span class="re_beloong">대국경북과학기술원</span>
	                                <ul class="tag_box">
	                                    <li>#자율주행</li>
	                                    <li>#고령운전자</li>
	                                    <li>#안전</li>
	                                </ul>
	                                <ul class="step_tech">
	                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
	                                </ul>
	                            </div>
	                            <button type="button" class="history_btn "><span>이력보기</span></button>
	                        </div>
	                        <div class="row col-box">
	                            <div class="col">
	                                <span class="row_txt_num blind">1</span>
	                                <span class="txt_left row_txt_tit txt_line txt_ellip "><!-- 말줄임표 없애는 스타일 txt_ellip 클래스 제거 --><a href="javascript:void(0);"  title="기술 상세보기">자율주행 ADAS 센서자율주행 ADAS 센서자율주행자율주행 ADAS 센서자율주행 ADAS 센서 ADAS 센서</a> </span>
	                                <span class="update_date">최근 업데이트 일자 : 2023.07.26</span>
	                                <ul class="tag_box">
	                                    <li>#자율주행</li>
	                                    <li>#고령운전자</li>
	                                    <li>#안전</li>
	                                </ul>
	                                <ul class="step_tech">
	                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
	                                </ul>
	                            </div>
	                            <span class="arrow"></span>
	                           
	                            <div class="col">
	                                <span class="row_txt_num blind">2</span>
	                                <span class="txt_left row_txt_tit"><a href="javascript:void(0);"  title="연구자 상세보기">손준우 연구자</a> </span>
	                                <span class="re_beloong">대국경북과학기술원</span>
	                                <ul class="tag_box">
	                                    <li>#자율주행</li>
	                                    <li>#고령운전자</li>
	                                    <li>#안전</li>
	                                </ul>
	                                <ul class="step_tech">
	                                    <li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">자율주행자동차</span></li>
	                                    <li><span class="mr txt_grey tech_nm ">운전자 편의</span></li>
	                                </ul>
	                            </div>
	                            <button type="button" class="history_btn "><span>이력보기</span></button>
	                        </div>
	                        <!-- list -->
	                        
	                        <!-- 데이터 없을때 -->
	                        <div class="row">
	                            <div class="empty_data">
	                                <p>아직 매칭된 정보가 없습니다.</p>
	                            </div>
	                        </div>
		                  </div>
		                  
		                  <div class="tbl_comm tbl_public">
                                <table class="tbl">
                                    <caption class="caption_hide">메인 과제신청 대상사업 리스트</caption>
                                    <colgroup>
                                        <col style="width:150px;">
                                        <col>
                                        <col style="width: 300px;">
                                        <col style="width: 300px;">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">일자</th>
                                            <th scope="col">내용</th>
                                            <th scope="col">기업수요 담당자</th>
                                            <th scope="col">연구자 담당자</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                         <tr>
                                             <td>23.07.31</td>
                                             <td class="ta_left">첫 컨택 – 유선통화 이후 오프라인 미팅 잡음</td>
                                             <td>홍길동 010-1234-1234 hjd@qwe.qwe</td>
                                             <td>아무개 010-4567-4567 amg@qwe.qwe</td>
                                         </tr>
                                         <tr>
                                             <td>23.07.31</td>
                                             <td class="ta_left">첫 컨택 – 유선통화 이후 오프라인 미팅 잡음</td>
                                             <td>홍길동 010-1234-1234 hjd@qwe.qwe</td>
                                             <td>아무개 010-4567-4567 amg@qwe.qwe</td>
                                         </tr>
                                    </tbody>
                                </table>
                            </div>
		              </div>
	              <!-- 매칭된 연구자-기술수요 목록 //end -->
	              
				</div>
			</div>
		</div>
	</div>
</form>