<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>

$(document).ready(function(){

});


//기술분야 분류 검색
$('#stdClassSrch').click(function() {
	var $href = $(this).attr('href');
	var op = $(this);
    layer_popup($href, op);
});

//키워드분야 클릭
function keywordClick(corporate_no, tech_class_nm){
 	var url = "/techtalk/doCorporateKeywordResultX.do";
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
    	   
			ahtml +="<div class='cont_list'>"
			if(res.data.length == 0){
				ahtml +="<div class='row'><p style='text-align:center'>기업수요가 없습니다.</p></div>"
			}else{
				for(var i=0; i<res.data.length;i++){
				ahtml +="<div class='row'>"
				ahtml +="<span class='row_txt_num blind'>"+res.data[i].corporate_no+"</span>"
				ahtml +="<span class='txt_left row_txt_tit'>"
				ahtml +="<a href=javascript:void(0); onclick=corporateDetail("+res.data[i].corporate_no+")>"+res.data[i].tech_class_nm +"</a></span>"
				ahtml +="<span class='co_update_dt'>"+res.data[i].co_update_dt+"</span>"
				ahtml +="<ul class='step_tech'>"
				ahtml +="<li><span class='mr txt_grey tech_nm '>"+res.data[i].keyword+"</span></li></ul>"
				ahtml +="</div>"
				}
			}
			ahtml +="</div>"
			$('.list_panel').empty();
    		$('.list_panel').append(ahtml);
    	   
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
function corporateDetail(corporate_no){
	var frm = document.createElement('form'); 

	frm.name = 'frm3'; 
	frm.method = 'post'; 
	frm.action = '/techtalk/viewCorprateDetail.do'; 

	var input1 = document.createElement('input'); 

	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "corporate_no"); 
	input1.setAttribute("value", corporate_no); 

	frm.appendChild(input1); 
	
	document.body.appendChild(frm); 
	frm.submit();
	
}

//엔터키 눌렀을때
function enterKeyClick(e){
	if(e.keyCode == 13){
		e.preventDefault();
		keywordClick();
		return false;
	};
}
</script>

<form id="frm" name="frm" action ="/techtalk/doCorporateKeywordResult.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<div class="sch_ctgr_wrap">
					<ul class="sch_ctgr_link">
						<li class="sch_ctgr_item item_author"><a href="/techtalk/reTechList.do">연구자 검색<span class="ir_text check-text">(선택됨)</span></a></li>
						<li class="sch_ctgr_item item_type active"><a href="/techtalk/coTechList.do">기업수요 검색</a></li>
					</ul>
				</div>       
				<div class="sch_ctgr_list">
					<div class="sch_block_scroll">
						<ul class="sch_list_wrap sch_block_wrap" >
							<li><a href="/techtalk/coTechList.do" class="sch_list_btn " title="기술분야" data-d-ategory="">기술분야</a></li>
							<li><a href="/techtalk/coKeyList.do" class="sch_list_btn last active" title="키워드검색" data-d-ategory="도서">키워드검색</a></li>
						</ul>
					</div>
				</div>     
				<!-- page_title s:  -->            
            <div class="area_cont">
					<div class="search_box">
						<p class="p_t"><strong>핵심 키워드</strong>를 통해 <strong>주요 연구자</strong>를 찾아보세요.</p>
						<div class="search_box_inner">
							<div class="search_keyword_box">
								<input type="text" class="keyword_input" id="keyword" name="keyword" onkeypress="enterKeyClick(event)" placeholder="키워드를 입력하세요." value="" title="검색어"/>
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
											<span class="row_txt_num blind">${ data.corporate_no }</span>
											<span class="txt_left row_txt_tit"><a href="javascript:void(0);" onclick="corporateDetail('${data.corporate_no}')" title="연구자${data.tech_class_nm }상세보기">${ data.tech_class_nm } </a> </span>
											<span class="co_update_dt">${ data.co_update_dt }</span>
											<ul class="step_tech">
												<li><span class="mr txt_grey tech_nm ">${ data.keyword }</span></li>
											</ul>
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td colspan="6">작성된 게시물이 없습니다.</td>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<di<%-- v class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">연구자 리스트</caption>
							<colgroup>
								<col style="width:5%" />
								<col style="width:20%" />
								<col style="width:15%" />
								<col style="width:15%" />
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>기술명</th>
									<th>업데이트 일자</th>
									<th>키워드</th>
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<tr>
											<td>${ data.corporate_no }</td>
											<td>
												<a href="javascript:void(0);" onclick="corporateDetail('${data.corporate_no}','${data.tech_class_nm}')" title="연구자${data.tech_class_nm }상세보기">${ data.tech_class_nm }</a> 
											</td>
											<td>${ data.co_update_dt }</td>			
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
					</di --%>v>
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

