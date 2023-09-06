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


//기술분야 분류 검색
$('#stdClassSrch').click(function() {
	var $href = $(this).attr('href');
	var op = $(this);
    layer_popup($href, op);
});

//키워드분야 클릭
function keywordClick(research_no, research_seqno, keyword){
 	var url = "/techtalk/doKeywordResult.do";
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
					ahtml +=	"<td >"
					ahtml +=	"<a href=javascript:void(0); onclick=researchDetail("+res.data[i].research_no+","+res.data[i].research_seqno+","+res.data[i].keyword+")>"+res.data[i].re_nm +"</a>"
					ahtml +=	"</td>"
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

//연구자 상세보기 화면
function researchDetail(research_no, research_seqno, keyword){
	var frm = document.createElement('form'); 

	frm.name = 'frm3'; 
	frm.method = 'post'; 
	frm.action = '/techtalk/viewResearchDetail.do'; 

	var input1 = document.createElement('input'); 
	var input2 = document.createElement('input'); 
	var input3 = document.createElement('input'); 

	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "research_no"); 
	input1.setAttribute("value", research_no); 
	input2.setAttribute("type", "hidden"); 
	input2.setAttribute("name", "research_seqno"); 
	input2.setAttribute("value", research_seqno); 
	input3.setAttribute("type", "hidden"); 
	input3.setAttribute("name", "keyword"); 
	input3.setAttribute("value", keyword); 

	frm.appendChild(input1); 
	frm.appendChild(input2); 
	frm.appendChild(input3); 
	
	document.body.appendChild(frm); 
	frm.submit();
	
}
    
</script>

<form id="frm" name="frm" action ="/techtalk/doKeywordResult.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<div class="sch_ctgr_wrap">
				<ul class="sch_ctgr_link">
					<li class="sch_ctgr_item item_type active"><a href="/techtalk/researchTechList.do">연구자 검색<span class="ir_text check-text">(선택됨)</span></a></li>
					<li class="sch_ctgr_item item_author"><a href="/techtalk/businessList.do">기업수요 검색</a></li>
				</ul>
			</div>
			
			<div class="sch_ctgr_list">
				<div class="sch_block_scroll">
					<ul class="sch_list_wrap sch_block_wrap" >
						<li><a href="/techtalk/reTechList.do" class="sch_list_btn " title="기술분야" data-d-ategory="">기술분야</a></li>
						<li><a href="/techtalk/reKeyList.do" class="sch_list_btn last active" title="키워드검색" data-d-ategory="도서">키워드검색</a></li>
					</ul>
				</div>
			</div>
			
			
            <!-- page_title s:  -->
			
            
            <!-- <a href="javascript:void(0);" onClick="keywordClick();" class="btn_step" title="검색">검색</a> -->
            
            <div class="area_cont">
					<div class="search_box">
						<p class="p_t"><strong>핵심 키워드</strong>를 통해 <strong>주요 연구자</strong>를 찾아보세요.</p>
						<div class="search_box_inner">
							<div class="search_keyword_box">
								<input type="text" class="keyword_input" id="keyword" name="keyword" placeholder="키워드를 입력하세요." value="" title="검색어"/>
							</div>
							<div class="btn_wrap">
								<button type="button" class="btn_step" onclick="javascript:keywordClick();" title="검색">
									<span>검색</span>
								</button>
								<!-- <a href="javascript:void(0);" onClick="keywordClick();" class="btn_step">검색</a> -->
							</div>
						</div>
					</div>	
					<div class="subject_corp">
						<h3 class="tbl_ttc">
							연구자 목록 
						</h3>
					</div>			
					<!-- page_content s:  -->
					<div class="list_panel">
						<div class="cont_list">
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<div class="row">
											<span class="row_txt_num blind">${ data.research_seqno }</span>
											<span class="txt_left row_txt_tit"><a href="javascript:void(0);" onclick="researchDetail('${data.research_no}','${data.research_seqno}','${data.keyword}')" title="연구자${data.re_nm }상세보기">${ data.re_nm } 연구자</a> </span>
											<span class="re_beloong">${ data.re_belong }</span>
											<ul class="step_tech">
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm1 }</span></li>
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm2 }</span></li>
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm3 }</span></li>
											</ul>
											
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<div class="row"><p style="text-align:center">게시물이 없습니다.</p></div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				
					<%-- <div class="tbl_comm tbl_public">
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
											<td>
												<a href="javascript:void(0);" onclick="researchDetail('${data.research_no}','${data.research_seqno}','${data.keyword}')" title="연구자${data.re_nm }상세보기">${ data.re_nm }</a> 
											</td>
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
					</div> --%>
					<div class="paging_comm">${ sPageInfo }</div>
				</div>
			</div>
			<!-- page_content s:  -->
			<!-- //page_content e:  -->
		</div>
	</div>
</form>

<!-- //compaVcContent e:  -->

