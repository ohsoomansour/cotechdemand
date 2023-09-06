# tibiz
jdk 1.8
springboot
sts4


기동방법
resource 폴더 application.yml 파일에서
profiles:
	active: local 확인 후 
springboot로 실행
시작 실패시 프로젝트 우측 클릭 후
maven -> update project 클릭하고 재시작

계정정보
admin/admin   -> member_type = 관리자 
tlo/tlo       -> member_type = TLO
business      -> member_type = 기업
test          -> member_type = 연구자

- 추가테이블 목록 - 23.09.06 11:11
tbresearch  연구자 DB
tbcorporate 기업수요 DB


- 공통규칙 - 23.09.06 11:07

1.유저정보 세션관련 처리

유저정보 불러올때 예시

@RequestMapping("/~~")
public ModelAndView doXXX(HttpServletRequest request){
	HttpSession session = request.getSession();
	String biz_name = session.getAttribute("biz_name").toString();
}


현재 로그인 시 세션이 담기는 정보

	session.setAttribute("member_seqno", userMap.get("member_seqno").toString());
	session.setAttribute("member_type", userMap.get("member_type").toString());
	session.setAttribute("id", userMap.get("id").toString());
	session.setAttribute("user_name", userMap.get("user_name").toString());
	session.setAttribute("user_email", userMap.get("user_email").toString());
	session.setAttribute("user_depart", userMap.get("user_depart").toString());
	session.setAttribute("user_rank", userMap.get("user_rank").toString());
	session.setAttribute("pw_temp_flag", userMap.get("pw_temp_flag").toString());
	session.setAttribute("pw_next_change_date", userMap.get("pw_next_change_date").toString());
	session.setAttribute("agree_flag", userMap.get("agree_flag").toString());
	session.setAttribute("delete_flag", userMap.get("delete_flag").toString());
	session.setAttribute("biz_name", userMap.get("biz_name").toString());
    
    
2.모든 소스 추가 및 수정 시 각 기능별 (function, method 등)에 관한 주석 추가 및 수정
 - java controller의경우 예시

/**
	 *
	 * @Author   : ycjo 
	 * @Date	 : 2020. 6. 2.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문계획에 포함되어 있는 설문지 목록
	 * @Explain  : 
	 *
	 */
     
 - xml의 경우
 <select id="SubjectFrontSQL.doInsertSubject"
		parameterType="dataMap" resultType="dataMap">
		/*
		2021.04.21 박성민
		SQL ID : SubjectFrontSQL.doInsertSubject
		사업참여
		*/
        
- jsp script의경우
//링크태우기 23.09.06 박성민
    function doHref(href){
				location.href = href
    }
    

    
    
    
-현재 퍼블리시 요청 내역 - 23.09.06 11:09

tibiz - 퍼블요청페이지
개인정보처리방침  /techtalk/policy.do
이용약관 /techtalk/terms.do
키워드검색 /techtalk/reKeyList.do
메인페이지 /techtalk/mainView.do
기업수요정보 /techtalk/viewCorprateDetail.do
로그인 /techtalk/login.do
회원가입 /techtalk/memberJoinFormPage.do

