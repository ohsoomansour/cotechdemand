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

//분류 변경
function clickCode(code_key,parent_depth,name_path){
	var next_depth = null;
	var url = "/techtalk/doClickCodeResult.do";
	if(parent_depth == "1"){
		parent_depth ="2";
		next_depth = "3";
	}else if(parent_depth == "2"){
		parent_depth ="3";
	}else if(parent_depth == "3"){
		parent_depth ="4";
	}

	$.ajax({
		url : url,
       type: "post",
       data: {
    	   code_key : code_key,
    	   parent_depth : parent_depth,
    	   next_depth : next_depth,
    	   name_path : name_path
    	   
       },
       dataType: "json",
       success : function(res){
    	   var split_code = res.stdMainCode[0].name_path.split("^");
    	   
           if(parent_depth == "2"){
    	   var ahtml= "";
    	  	 	ahtml +=split_code[0]
    	  	 	ahtml += "&nbsp;"
				ahtml +="<div class='form-inline pop-search-box' id='codeBox'>"
				ahtml +="중분류"
				ahtml +="<div>"
				for(var i=0; i<res.stdMainCode.length;i++){
					ahtml +="<div>"
					ahtml +="<a href=javascript:void(0); onclick=clickCode("+res.stdMainCode[i].code_key+","+res.stdMainCode[i].code_depth+","+"'"+res.stdMainCode[i].name_path+"'"+")>"+res.stdMainCode[i].code_name +"</a>"
					ahtml +="</div>"
				}
				ahtml +="</div>"
				ahtml +="<br/>"
				ahtml +="세분류"
				ahtml +="<div>"
				for(var i=0; i<res.stdMainCode.length;i++){
					ahtml +="<div>"
					ahtml +=res.stdMainCode[i].count_result
					ahtml +="</div>"
				}
				ahtml +="</div>"
				ahtml +="</div>"
				$('#codeBox').empty();
	    		$('#codeBox').append(ahtml);
	    		console.log(res.data.length);
	    		var ahtml= "";
					ahtml +="<div class='cont_list'>"
	   				if(res.data.length == null){
	   					ahtml +="<td colspan='6'>연구자가 없습니다.</td>"
	   	   	   		}else{   	   	   	   		
   					for(var i=0; i<res.data.length;i++){
   					ahtml +="<div class='row'>"
   						ahtml +="<span class='row_txt_num blind'>"+res.data[i].research_seqno+"</span>"
   						ahtml +="<span class='txt_left row_txt_tit'>"
   						ahtml +="<a href=javascript:void(0); onclick=researchDetail("+res.data[i].research_no+","+res.data[i].research_seqno+","+res.data[i].keyword+")>"+res.data[i].research_nm +"연구자</a> </span>"
   						ahtml +="<span class='re_beloong'>"+ res.data[i].applicant_nm+" </span>"
   						ahtml +="<ul class='step_tech'>"
   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm1+"</span></li>"
   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm2+"</span></li>"
   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm3+"</span></li></ul>"
   						ahtml +="<span class='mr txt_grey keyword'  >"+res.data[i].keyword+"</span>"
   						ahtml +="</div>"	

   					}
   					ahtml +="</div>"
   					ahtml +="</div>"
   					$('#tbl').empty();
   		    		$('#tbl').append(ahtml);
	   	   		}
	    		
           }else if(parent_depth == "3"){
        	   var ahtml= "";
   	  	 	ahtml +=split_code[0]
   	  	 	ahtml += "&nbsp; > "
   	  	 	ahtml +=split_code[1]
				ahtml +="<div class='form-inline pop-search-box' id='codeBox'>"
				ahtml +="소분류"
				ahtml +="<div>"
				for(var i=0; i<res.stdMainCode.length;i++){
					ahtml +="<div>"
						ahtml +="<a href=javascript:void(0); onclick=clickCode("+res.stdMainCode[i].code_key+","+res.stdMainCode[i].code_depth+","+"'"+res.stdMainCode[i].name_path+"'"+")>"+res.stdMainCode[i].code_name +"</a>"
					ahtml +="</div>"
				}
				ahtml +="</div>"
				ahtml +="<br/>"
				ahtml +="</div>"
				ahtml +="</div>"
				$('#codeBox').empty();
	    		$('#codeBox').append(ahtml);
	    		
	    		var ahtml= "";
					ahtml +="<div class='cont_list'>"
	   				if(res.data == null){
	   					ahtml +="<td colspan='6'>연구자가 없습니다.</td>"
	   	   	   		}else{   	   	   	   		
   					for(var i=0; i<res.data.length;i++){
   					ahtml +="<div class='row'>"
   						ahtml +="<span class='row_txt_num blind'>"+res.data[i].research_seqno+"</span>"
   						ahtml +="<span class='txt_left row_txt_tit'>"
   						ahtml +="<a href=javascript:void(0); onclick=researchDetail("+res.data[i].research_no+","+res.data[i].research_seqno+","+res.data[i].keyword+")>"+res.data[i].research_nm +"연구자</a> </span>"
   						ahtml +="<span class='re_beloong'>"+ res.data[i].applicant_nm+" </span>"
   						ahtml +="<ul class='step_tech'>"
   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm1+"</span></li>"
   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm2+"</span></li>"
   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm3+"</span></li></ul>"
   						ahtml +="<span class='mr txt_grey keyword'  >"+res.data[i].keyword+"</span>"
   						ahtml +="</div>"	

   					}
   					ahtml +="</div>"
   					ahtml +="</div>"
   					$('#tbl').empty();
   		    		$('#tbl').append(ahtml);
	   	   		}
		    		
           }else if(parent_depth =="4"){
        	   var ahtml= "";
        	   ahtml +=split_code[0]
   	    		ahtml += "&nbsp; > "
   	    		ahtml +=split_code[1]
   	    		ahtml += "&nbsp; > "
   	   	    	ahtml +=split_code[2]
   	    		ahtml +="<div class='form-inline pop-search-box' id='codeBox'>"
   					ahtml +="<div>"
   					ahtml +="</div>"
   					ahtml +="<br/>"
   					ahtml +="</div>"
   					$('#codeBox').empty();
   		    		$('#codeBox').append(ahtml);
    		   
   		    		var ahtml= "";
   					ahtml +="<div class='cont_list'>"
   	   				if(res.data == null){
   	   					ahtml +="<td colspan='6'>연구자가 없습니다.</td>"
   	   	   	   		}else{   	   	   	   		
	   					for(var i=0; i<res.data.length;i++){
	   					ahtml +="<div class='row'>"
	   						ahtml +="<span class='row_txt_num blind'>"+res.data[i].research_seqno+"</span>"
	   						ahtml +="<span class='txt_left row_txt_tit'>"
	   						ahtml +="<a href=javascript:void(0); onclick=researchDetail("+res.data[i].research_no+","+res.data[i].research_seqno+","+res.data[i].keyword+")>"+res.data[i].research_nm +"연구자</a> </span>"
	   						ahtml +="<span class='re_beloong'>"+ res.data[i].applicant_nm+" </span>"
	   						ahtml +="<ul class='step_tech'>"
	   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm1+"</span></li>"
	   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm2+"</span></li>"
	   						ahtml +="<li><span class='mr txt_grey tech_nm' >"+res.data[i].tech_nm3+"</span></li></ul>"
	   						ahtml +="<span class='mr txt_grey keyword'  >"+res.data[i].keyword+"</span>"
	   						ahtml +="</div>"	
	
	   					}
	   					ahtml +="</div>"
	   					ahtml +="</div>"
	   					$('#tbl').empty();
	   		    		$('#tbl').append(ahtml);
   	   	   			}
               }
           
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
						<li class="sch_ctgr_item item_author"><a href="/techtalk/reTechList.do">연구자 검색<span class="ir_text check-text">(선택됨)</span></a></li>
						<li class="sch_ctgr_item item_type active"><a href="/techtalk/coTechList.do">기업수요 검색</a></li>
					</ul>
				</div>       
				<div class="sch_ctgr_list">
					<div class="sch_block_scroll">
						<ul class="sch_list_wrap sch_block_wrap" >
							<li><a href="/techtalk/coTechList.do" class="sch_list_btn last active" title="기술분야" data-d-ategory="">기술분야</a></li>
							<li><a href="/techtalk/coKeyList.do" class="sch_list_btn " title="키워드검색" data-d-ategory="도서">키워드검색</a></li>
						</ul>
					</div>
				</div> 
            <!-- page_title s:  -->
			

            
            <div class="area_cont">
            	<div class="form-inline pop-search-box" id="codeBox">
            		대분류
            		<div>
	            		<c:forEach var ="item" items="${ stdMainCode }" >
	            			<div>
	            				<a href="javascript:void(0);" onclick="clickCode('${item.code_key}', '${item.code_depth}', '${item.name_path}');return false">${item.code_name }</a>
	            			</div>
	            		</c:forEach>
            		</div>
            		<br/>
            		세분류
            		<div>
            			<c:forEach var ="item" items="${ stdMainCode }" >
	            			<div>
	            				<c:out value="${item.count_result}"></c:out>
	            			</div>
	            		</c:forEach>
            		</div>
				</div>
            	
            	<div class="subject_corp">
						<h3 class="tbl_ttc">
							기업수요 목록 
						</h3>
				</div>			
					<!-- page_content s:  -->
					<div class="list_panel" id="tbl">
						<div class="cont_list">
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<div class="row">
											<span class="row_txt_num blind">${ data.research_seqno }</span>
											<span class="txt_left row_txt_tit"><a href="javascript:void(0);" onclick="researchDetail('${data.research_no}','${data.research_seqno}','${data.keyword}')" title="연구자${data.research_nm }상세보기">${ data.research_nm } </a> </span>
											<span class="re_beloong">${ data.applicant_nm }</span>
											<ul class="step_tech">
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm1 }</span></li>
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm2 }</span></li>
												<li><span class="mr txt_grey tech_nm ">${ data.tech_nm3 }</span></li>
												
											</ul>
												<span class="mr txt_grey keyword ">${ data.keyword }</span>
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td colspan="6">연구자가 없습니다.</td>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
            	<%-- <div class="subject_corp">
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
											<td>
												<a href="javascript:void(0);" onclick="researchDetail('${data.research_no}','${data.research_seqno}','${data.keyword}')" title="연구자${data.research_nm }상세보기">${ data.research_nm }</a> 
											</td>
											<td>${ data.re_nm }</td>
											<td>${ data.applicant_nm }</td>
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
				<!-- page_content s:  -->
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

