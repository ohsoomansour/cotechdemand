<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>

$(document).ready(function(){
	setTimeout(function(){
		$('#sc_keywd').focus();
	}, 500);	
});

function testInputClick(){
	var url = "/techtalk/researchListCheck.do";
	var form = $('#frm')[0];
	var data = new FormData(form);
	$.ajax({
		url : url,
       type: "post",
       processData: false,
       contentType: false,
       data: data,
       dataType: "json",
       success : function(res){
          /*console.log(res);
          console.log(res.dataMapList);
          console.log(res.dataMapList[0]);
          $('#result').append(res.dataMapList[0].member_seqno);*/
       },
       error : function(){
    	alert('실패했습니다.');    
       },
       complete : function(){

       }
	});  
	
}

//기술분야 분류 검색
$('#stdClassSrch').click(function() {
	var $href = $(this).attr('href');
	var op = $(this);
    layer_popup($href, op);
});

//키워드분야 클릭
function keywordClick(){
 	var url = "/techtalk/doKeywordResult.do";
 	var form = $('#frm')[0];
 	console.log(form);
	var data = new FormData(form);
	$.ajax({
		url : url,
       type: "post",
       processData: false,
       contentType: false,
       data: data,
       dataType: "json",
       success : function(res){
    	   console.log(res.data)
    	   var ahtml= "";
    	   
				ahtml +="<table class='tbl'>"
				ahtml +="<caption class='caption_hide'>연구자 리스트</caption>"
				ahtml +="<colgroup>"
				ahtml +="<col style='width:5%' />"
				ahtml +="<col style='width:10%' />"
				ahtml +="<col style='width:20%' />"
				ahtml +="<col style='width:15%' />"
				ahtml +="<col style='width:15%' />"
				ahtml +="<col style='width:15%' />"
				ahtml +="<col style='width:15%' />"
				ahtml +="</colgroup>"
				ahtml +="<thead>"
				ahtml +="<tr>"
				ahtml +="<th>번호</th>"
				ahtml +="<th>연구자명</th>"
				ahtml +="<th>출원인</th>"
				ahtml +="<th>기술분류1</th>"
				ahtml +="<th>기술분류2</th>"
				ahtml +="<th>기술분류3</th>"
				ahtml +="<th>키워드</th>"
				ahtml +="<tr>"
				ahtml +="</thead>"
				ahtml +="<tbody>"
				for(var i=0; i<res.data.length;i++){
				ahtml +="<tr>"
					ahtml +=	"<td >"+res.data[i].research_seqno+"</td>"
					/* ahtml +=	"<a href="javascript:void(0);" onclick="researchDetail(res.data[i].research_seqno)" title="연구자res.data[i].research_seqno 상세보기">"res.data[i].research_seqno"</a>" */
					ahtml +=	"<td >"+res.data[i].re_nm+"</td>"
					ahtml +=	"<td >"+res.data[i].re_belong+"</td>"
					ahtml +=	"<td >"+res.data[i].tech_nm1+"</td>"
					ahtml +=	"<td >"+res.data[i].tech_nm2+"</td>"
					ahtml +=	"<td >"+res.data[i].tech_nm3+"</td>"
					ahtml +=	"<td >"+res.data[i].keyword+"</td>"
				ahtml +="<tr>"
				}
				ahtml +="</tbody>"
				ahtml +="</table>"
				$('.tbl').empty();
	    		$('.tbl').append(ahtml);
    	   
       },
       error : function(){
    	alert('실패했습니다.');    
       },
       async:false,
       complete : function(){

       }
	});
}

function researchDetail(research_seqno){
	$('#research_seqno').val(research_seqno);
}
    
</script>
<form action="/techtalk/researchDetail.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="research_seqno" name="research_seqno" value=""/>
</form>
<form id="frm" name="frm" action ="/techtalk/doKeywordResult.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <!-- page_title s:  -->
			<div class="area_tit">
				<a href="/techtalk/researchTechList.do" title="연구자검색">연구자검색</a>
			</div>	
			<div class="area_tit">
				<a href="/techtalk/businessList.do" title="기업수요 검색 버튼">기업수요 검색</a>
            </div>    
            
            <a href="/techtalk/researchTechList.do" id="techFieldTab" >기술분야</a>
            <a href="/techtalk/researchKeyList.do" id="keyFieldTab" >키워드분야</a>
            
            <!-- <a href="javascript:void(0);" onClick="keywordClick();" class="btn_step" title="검색">검색</a> -->
            
            <div class="area_cont">
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box">
								<input type="text" class="b_name" id="keyword" name="keyword" placeholder="키워드를 입력하세요." value="" title="검색어"/>
							</div>
							<div class="btn_wrap">
								<!-- <button type="submit" class="btn_step" onclick="keywordClick();">
									<span>검색</span>
								</button> -->
								<a href="javascript:void(0);" onClick="keywordClick();">검색</a>
							</div>
						</div>
					</div>	
					<div class="subject_corp">
						<h3 class="tbl_ttc">
							연구자 목록 
						</h3>
					</div>			
				<!-- page_content s:  -->
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">연구자 리스트</caption>
							<colgroup>
								<col style="width:5%" />
								<col style="width:10%" />
								<col style="width:20%" />
								<col style="width:15%" />
								<col style="width:15%" />
								<col style="width:15%" />
								<col style="width:15%" />
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>연구자명</th>
									<th>출원인</th>	
									<th>기술분류1</th>
									<th>기술분류2</th>
									<th>기술분류3</th>
									<th>키워드</th>
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<tr>
											<td>${ data.research_seqno }</td>
											<%-- <a href="javascript:void(0);" onclick="researchDetail('${data.research_seqno}')" title="연구자${data.re_nm }상세보기">${ data.re_nm }</a> --%> 
											<td>${ data.re_nm }</td>
											<td>${ data.re_belong }</td>
											<td>${ data.tech_nm1 }</td>			
											<td>${ data.tech_nm2 }</td>			
											<td>${ data.tech_nm3 }</td>			
											<td>${ data.keyword }</td>			
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td colspan="6">작성된 게시물이 없습니다.</td>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>
					<div class="paging_comm">${ sPageInfo }</div>
				</div>
            
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<!-- //page_content e:  -->
		</div>
	</div>
</form>

<!-- //compaVcContent e:  -->
