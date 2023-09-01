<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	<script>
		$(document).ready(function() {
			// Top Button Scroll
			$(window).scroll(function(){
				if($(this).scrollTop() >= "300") {
					$(".scroll-top").addClass("fixed");
					$(".scroll-top button").attr("tabindex","0");
				} else {
					$(".scroll-top").removeClass("fixed");
					$(".scroll-top button").attr("tabindex","-1");
				}
			})

			$('.scroll-top button').click(function(){
				$('body,html').animate({scrollTop:0}, 300
					,function(){ 
					$("#compaVcHead").removeClass('hide-gnb');
				});
			});
		})
	</script>
		<!-- compaVcFooter s:  -->
		<div class="scroll-top" >
			<button tabindex="-1" title="위로">
				<svg version="1.1" focusable="false" id="layer1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
					 y="0px" viewBox="0 0 768 768" style="enable-background:new 0 0 768 768;" xml:space="preserve">
				<g>
					<g>
						<path class="st0" d="M496.2,420.4l-99.1-99.1c-7.7-7.7-20.2-7.7-28,0L270,420.4c-6.4,7.4-6.4,18.4,0,25.8c7.1,8.3,19.7,9.3,28,2.2
							l85.1-85.1l85.3,85.1c7.7,7.7,20.2,7.7,28,0C503.9,440.6,503.9,428.1,496.2,420.4z"></path>
					</g>
				</g>
				</svg>
				<span class="screen_out">위로</span>
			</button>
		</div>
		
        <footer id="compaVcFoot" class="foot_cv">
            <div class="wrap_copyright">
                <div class="inner_copyright">
					<div class="foot_logo">
						<div style="display:inline-block">
						<span><img src="${pageContext.request.contextPath}/css/images/common/footer_logo.png" alt="바우처사업관리시스템"></span>
						</div>
					</div>
					<div class="dim-layer-common alertCls">
					    <div class="dimBgg"></div>
					    <div id="layer99" class="pop-layer" style="height:220px">
					        <div class="pop-container">
					        <div class="pop-title"><h3>알림</h3></div>
					            <div id="tap1_1" style="display: block">
									<div class="table2 mTop5">
										<div class="line form-inline alignCenter">
											<div style="margin-top: 30px">
												<label id="alertTxt">ㅅㄷㅌㅅ</label>
											</div>
										</div>
										<div class="tbl_public" >
											<div style="text-align:center;margin-top:20px;">
							                	<button type="button" class="btn_step" id="cancelAlert" name="btnCancel" title="닫기">닫기</button>
						                	</div>
						                </div>
									</div>
								</div>
					        </div>
				    	</div>
					</div>
                    <div class="info_copyright">
						<div class="info_addr">
							<span class="txt_addr"><a href="/techtalk/terms.do" class="txt_addr" style="width:80px;display:contents;" title="이용약관">이용약관</a> 
							<a href="/techtalk/policy.do" class="txt_addr" style="width:200px;display:contents;" title="개인정보처리방침">개인정보처리방침</a></span>
				
							<span class="txt_addr">대표전화 : 02-6405-3271 F.02-6405-3277<br/>
							(우) 06234 서울특별시 강남구 테헤란로10길 18, 6층</span>
						
						</div>
						<small class="txt_copyright">COPYRIGHT(C) 2023. ALL RIGHT RESERVED.</small>
					</div>
					<div class="wa_banner">
						<a title="새창" href="http://www.wa.or.kr/board/list.asp?BoardID=0006" target="_blank">
							<img class="wa" alt="(사)한국장애인단체총연합회 한국웹접근성인증평가원 웹 접근성 우수사이트 인증마크(WA인증마크)" 
							 src="${pageContext.request.contextPath}/css/images/common/wa_mark.png" width="120px" height="84px" /> 
						</a>
					</div>
                        <div class="relation_svc">
	                        <strong class="tit_relation"><a href="javascript:void(0);" class="link_tit" aria-haspopup="true" aria-expanded="false" title="Family Site">Family Site<span class="icon ico_arr"></span></a></strong>
	                        <ul class="list_relation">
	                             <li><a href="https://www.keywert.com/" target="_blank" class="link_relation" title="Keywert">Keywart</a></li>
	                        </ul>
                    </div>
                </div>
            </div>
        </footer>