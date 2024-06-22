# 프로젝트 소개
- 이름: tbiz
- 설명: 필요한 기술을 보유한 연구자 수요 기업과 기업이 필요한 기술을 가진 연구자를 매칭하는 시스템   

### ⏲️프로젝트 개발 기간 
+ 2023.09.01 ~ 2023.11.01

### ⚙️개발 환경
+ **BackEnd language** : java (jdk1.8)
+ **FrontEnd language** : Javascript 
+ **library** : jQuery
+ **Framework** : SpringBoot sts4 
+ **Tool** : JSP
+ **Database** : Postgresql

# 📌주요 기능 담당 
## 관리자가 일반회원 관리
### 경로 
+ java/com/ttmsoft/lms/front/member/MemberAction.java 
+ java/com/ttmsoft/lms/front/member/MemberService.java
+ /techtalk/admin/member/member/adminMember.jsp
+ /techtalk/front/member/member/adminMemberForm.jsp
+ src/main/resources/sqlmap/postgres/voucher/member/Member_v_SQL.xml

## 기업 기술 수요 등록
### 경로
+ java/com/ttmsoft/lms/front/corporate/CoTechDemandAction.java
+ java/com/ttmsoft/lms/front/corporate/CoTechDemandService.java
+ /techtalk/front/corporateMypage/registCotechDemandForm.jsp
+ /techtalk/front/corporateMypage/coTechDemandList.jsp
+ src/main/resources/sqlmap/postgres/techtalk/site/CoTechDemandSQL.xml

## 기업 기술 수요 관리
### 경로
+ java/com/ttmsoft/lms/front/corporate/TLOMyPageAction.java
+ java/com/ttmsoft/lms/front/corporate/TLOMyPageService.java
+ + /techtalk/front/corporateMypage/TLOMypage.jsp

+ src/main/resources/sqlmap/postgres/techtalk/system/TLOPageSQL.xml

### 유저정보 세션관련 처리
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
