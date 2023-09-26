<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
var r_seqno;
var d_seqno;
var his_row;
$(document).ready(function(){
	//체크박스 변경 - 2023/09/21
    $("input:checkbox").change(function(){
      if(this.checked){
        $(this).attr('value', 'Y');
      }else{
        $(this).attr('value', 'N');    
      }
    });
	
   
	initDatePicker([$('#strDate'), $('#endDate')]);
	initDatePicker([$('#strDate2'), $('#endDate2')]);
	
	$('#filterBtn').click(function() {
		var $href = "#filterPop";
		var cls = "filterPop";
		var op = $(this);
	    layer_popup($href, cls, op);
	});
});

function layer_popup(el, cls, op){

    var $el = $(el);    //레이어의 id를 $el 변수에 저장
    var $op = $(op);    //레이어의 id를 $el 변수에 저장
    var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

    isDim ? $("."+cls).fadeIn() : $el.fadeIn();
    var inputId = $("."+cls).find("input").first().attr('id');
    setTimeout(function(){
    	$('#'+inputId).focus();
        }, 500);
    
    var $elWidth = ~~($el.outerWidth()),
        $elHeight = ~~($el.outerHeight()),
        docWidth = $(document).width(),
        docHeight = $(document).height();

    // 화면의 중앙에 레이어를 띄운다.
    if ($elHeight < docHeight || $elWidth < docWidth) {
        $el.css({
            marginTop: -$elHeight /2,
            marginLeft: -$elWidth/2
        })
    } else {
        $el.css({top: 0, left: 0});
    }

    //esc키 버튼 입력시 통보 없애기
    $(document).keydown(function(event) {
        if ( event.keyCode == 27 || event.which == 27 ) {
            $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
            $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        	setTimeout(function(){
            	$op.focus();
               }, 500);
            return false;
        }
    });
	
    
    $el.find('.btn_cancel,.btn-layerClose').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        
        setTimeout(function(){
        	$op.focus();
           }, 500);
        return false;
    });
    
}

//페이징 - 2023/09/21
function fncList(page) {
	$('#page').val(page);
	$('#frm').submit();
}

//검색 - 2023/09/21 
function doSearch(e) {
	$('#page').val(1);
	$('#frm').submit();
}

//목록관리 - 2023/09/21 
function doListAll(e) {
	$('#list').val('all');
	$('#page').val(1);
	$('#frm').submit();
}

//취소 - 2023/09/21
function doCancel(e) {
	$('#list').val();
	$('#page').val(1);
	$('#frm').submit();
}

//목록저장 - 2023/09/21
function doSave(e) {
	var researcher_list = $('input:checkbox[name="chk"]').length;

	var researcher_seqno = new Array(researcher_list);
	var view_yn = new Array(researcher_list);

	for(var i=0; i<researcher_list; i++){                          
		researcher_seqno[i] = $('input:checkbox[name="chk"]').eq(i).attr('id');
		view_yn[i] = $('input:checkbox[name="chk"]').eq(i).val();
	}
	
	$.ajax({
		type : 'POST',
		url : '/techtalk/doSaveListX.do',
		data : {
			researcher_seqno : researcher_seqno,
			view_yn : view_yn
		},
		dataType : 'json',
		success : function(res) {
			alert("저장되었습니다.");
			location.href = "/techtalk/tloMatchList.do";
		},
		error : function() {
			
		},
		complete : function() {
			
		}
	});
}

//필터 기술분류 변경 - 2023/09/21
function filterChangeStd(obj, gubun){
	var selValue = obj.value;
	if(selValue == "" || selValue == "선택"){
		if(gubun == "mid"){
			$('#filterStdClassCd2').empty();
			$('#filterStdClassCd3').empty();
			$('#filterStdClassCd2').append("<option title='기술분류2' value=''>선택</option>");
			if(selValue == "") {
				$('#filterStdClassCd2').attr('disabled', 'disabled');
			}
			$('#filterStdClassCd3').append("<option title='기술분류3' value=''>선택</option>");
			$('#filterStdClassCd3').attr('disabled', 'disabled');
		} else if(gubun == "sub" || gubun == "end") {
			$('#filterStdClassCd3').empty();
			$('#filterStdClassCd3').append("<option title='기술분류3' value=''>선택</option>");
			$('#filterStdClassCd3').attr('disabled', 'disabled');
		} 
	}else{
		$.ajax({
			type : 'POST',
			url : '/techtalk/deGetCodeListX.do',
			data : {
				parent_code_key : selValue,
				gubun : gubun
			},
			dataType : 'json',
			success : function(res) {
				var codeData = "";
				var aHtml = "";
				if(gubun == "mid"){
					codeData = res.codeList;
					aHtml += "<option title='기술분류2' value=''>선택</option>";
					$.each(codeData, function(key, val){
						aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
					});
					
					$('#filterStdClassCd2').empty();
					$('#filterStdClassCd2').append(aHtml);
					$('#filterStdClassCd2').removeAttr("disabled");	
				} else if(gubun == "sub") {
					codeData = res.codeList;
					aHtml += "<option title='기술분류3' value=''>선택</option>";
					$.each(codeData, function(key, val){
						aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
					});
					
					$('#filterStdClassCd3').empty();
					$('#filterStdClassCd3').append(aHtml);
					$('#filterStdClassCd3').removeAttr("disabled");	
				} 
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		});
	}
}

//필터 - 2023/09/21
function doSearchFilter () {
	$('#page').val(1);
	$('#frm2').submit();
}

function historyClick(demand_seqno, resear_no){
	r_seqno = resear_no;
	d_seqno = demand_seqno;
	
	$('#set').hide();
	$('#setUpdate').hide();
	$('#setCancel').hide();
	$('#updateRow').hide();
	$('#deleteRow').hide();
	
 	var url = "/techtalk/doTloMatchHistoryListX.do";
 	var form = $('#frm')[0];
	var data = new FormData(form);
	$.ajax({
		url : url,
       type: "post",
       data: {
    	   demand_seqno : demand_seqno,
    	   researcher_seqno : resear_no
       	},
       dataType: "json",
       success : function(res){
           his_row = res.data.length;
    	   var ahtml= "";

    	   ahtml +="<form action='#' id='tblFrm' name='tblFrm' method='post'>"
    	   ahtml +="<table class='tbl'>"
    	   ahtml +="<caption class='caption_hide'>메인 과제신청 대상사업 리스트</caption>"
    	   ahtml +="<colgroup>"
   		   ahtml +="<col style='width:170px;'>"
   		   ahtml +="<col>"
		   ahtml +="<col style='width: 300px;'>"
		   ahtml +="<col style='width: 300px;'>"
		   ahtml +="</colgroup>"
		   ahtml +="<thead>"
		   ahtml +="<tr>"
		   ahtml +="<th scope='col'>일자</th>"
		   ahtml +="<th scope='col'>내용</th>"
		   ahtml +="<th scope='col'>기업수요 담당자</th>"
		   ahtml +="<th scope='col'>연구자 담당자</th>"
		   ahtml +="</tr>"
		   ahtml +="</thead>"
		   ahtml +="<tbody id='row'>"
		   if(res.data.length > 0) {
				for(var i=0; i<res.data.length; i++){
				   if(res.data[i].business_tel == undefined){
					   res.data[i].business_tel = '';
				   }
				   if(res.data[i].business_email == undefined){
					   res.data[i].business_email = '';
				   }
				   if(res.data[i].researcher_tel == undefined){
					   res.data[i].researcher_tel = '';
				   }
				   if(res.data[i].researcher_email == undefined){
					   res.data[i].researcher_email = '';
				   }
				   ahtml +="<tr>"
				   ahtml +="<td>"+res.data[i].match_date+"</td>"
				   ahtml +="<td class='ta_left'>"+res.data[i].contents+"</td>"
				   ahtml +="<td>"+res.data[i].business_nm+" / "+res.data[i].business_tel+" / "+res.data[i].business_email+"</td>"
				   ahtml +="<td>"+res.data[i].researcher_nm+" / "+res.data[i].researcher_tel+" / "+res.data[i].researcher_email+"</td>"
				   ahtml +="</tr>"
				}
		   } else {
				ahtml +="<tr>"
				ahtml +="<td colspan='4' style='text-aline: centrer;'>매칭 이력이 없습니다.</td>"	
				ahtml +="</tr>"	
		   }
		   ahtml +="</tbody>"
		   ahtml +="</table>"
		   ahtml +="</form>"
		   $('#tbl').empty();
		   $('#tbl').append(ahtml);

		   $('#set').show();
       },
       error : function(){
    	alert('실패했습니다.');    
       },
       async:false,
       complete : function(){

       }
	});
}	
function doSet() {
   $('#set').hide();
   $('#updateRow').show();
   $('#deleteRow').show();
   $('#setUpdate').show();
   $('#setCancel').show();
}

function doSetCancel() {
	historyClick(d_seqno, r_seqno)
}

function doUpdateRow() {
	var ahtml = "";

	ahtml +="<tr>"
    ahtml +="<td><div class='datepicker_wrap'><input type='text' id='match_date' name='match_date[]' class='form-control match_date' placeholder='일자'/></div></td>"
    ahtml +="<td class='ta_left'><input type='text' id='contents' name='contents[]' placeholder='내용'/></td>"
    ahtml +="<td class='left'><div class='d-flex col1'>"
    ahtml +="<div class='row1 d-flex g5 al-c'><input type='text' id='business_nm' name='business_nm[]' style='text-align : center; width:18%; text-indent: 0;' placeholder='이름'/> / "
    ahtml +="<input type='text' id='business_tel1' name='business_tel1[]' style='text-align : center; width:20%; text-indent: 0;' placeholder='연락처1'/>-"
    ahtml +="<input type='text' id='business_tel2' name='business_tel2[]' style='text-align : center; width:20%; text-indent: 0;' placeholder='연락처2'/>-"
    ahtml +="<input type='text' id='business_tel3' name='business_tel3[]' style='text-align : center; width:20%; text-indent: 0;' placeholder='연락처3'/> / </div>"
    ahtml +="<div class='row1 mgt10 d-flex g5 al-c' ><input type='text' id='business_mail1' name='business_mail1[]' style='width: 30%;' onkeyup='this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');' maxlength='30' placeholder='이메일1'/> <span>@</span> "
    ahtml +="<input type='text' id='business_mail2' name='business_mail2[]' style='width: 40%; flex:1' onkeyup='this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');' maxlength='30' placeholder='이메일2'/>"  
    ahtml +="</div></div></td>"
    ahtml +="<td class='left'><div class='d-flex col1'>"
    ahtml +="<div class='row1 d-flex g5 al-c'><input type='text' id='researcher_nm' name='researcher_nm[]' style='text-align : center; width:18%; text-indent: 0;'placeholder='이름'/> / "
    ahtml +="<input type='text' id='researcher_tel1' name='researcher_tel1[]' style='text-align : center; width:20%; text-indent: 0;'placeholder='연락처1'/>-"
    ahtml +="<input type='text' id='researcher_tel2' name='researcher_tel2[]' style='text-align : center; width:20%; text-indent: 0;'placeholder='연락처2'/>-"
    ahtml +="<input type='text' id='researcher_tel3' name='researcher_tel3[]' style='text-align : center; width:20%; text-indent: 0;'placeholder='연락처3'/> / </div> "
    ahtml +="<div class='row1 mgt10 d-flex g5 al-c' ><input type='text' id='researcher_mail1' name='researcher_mail1[]' style='width: 30%;' onkeyup='this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');' maxlength='30'placeholder='이메일1'/> <span>@</span> "
    ahtml +="<input type='text' id='researcher_mail2' name='researcher_mail2[]' style='width: 40%;flex:1' onkeyup='this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');' maxlength='30'placeholder='이메일2'/ >"  
    ahtml +="</div></div></td>"
    ahtml +="</tr>"

	$('#row').append(ahtml);
	 initDatePicker([$('.match_date'), '']);
}

function doDeleteRow() {
	if($('#row tr').length <= his_row || $('#row tr').length <= 1) return;
	$('#tbl tr:last').remove();
}

function doSetUpdate() {
	if($('#row tr').length <= his_row || $('#row tr').length <= 1) return;

	var match_date = new Array();
	var contents = new Array();
	var business_nm = new Array();
	var business_tel = new Array();
	var business_mail = new Array();
	var researcher_nm = new Array();
	var researcher_tel = new Array();
	var researcher_mail = new Array(); 

	for(var i=0; i < $('input[name="match_date[]"]').length; i++) {
		match_date.push($('input[name="match_date[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="contents[]"]').length; i++) {
		contents.push($('input[name="contents[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="business_nm[]"]').length; i++) {
		business_nm.push($('input[name="business_nm[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="business_tel1[]"]').length; i++) {
		business_tel.push($('input[name="business_tel1[]"]')[i].value + "-"+ $('input[name="business_tel2[]"]')[i].value + "-" + $('input[name="business_tel3[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="business_mail1[]"]').length; i++) {
		business_mail.push($('input[name="business_mail1[]"]')[i].value + "@"+ $('input[name="business_mail2[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="researcher_nm[]"]').length; i++) {
		researcher_nm.push($('input[name="researcher_nm[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="researcher_tel1[]"]').length; i++) {
		researcher_tel.push($('input[name="researcher_tel1[]"]')[i].value + "-"+ $('input[name="researcher_tel2[]"]')[i].value + "-" + $('input[name="researcher_tel3[]"]')[i].value);
	}

	for(var i=0; i < $('input[name="researcher_mail1[]"]').length; i++) {
		researcher_mail.push($('input[name="researcher_mail1[]"]')[i].value + "@"+ $('input[name="researcher_mail2[]"]')[i].value);
	}

	if(!isBlank('매칭일자', '#match_date'))
	if(!isBlank('매칭내용', '#contents'))
	if(!isBlank('담당자이름', '#business_nm'))
	if(!isBlank('담당자전화번호', '#business_tel1'))
	if(!isBlank('담당자전화번호', '#business_tel2'))
	if(!isBlank('담당자전화번호', '#business_tel3'))
	if(!isBlank('담당자메일', '#business_mail1'))
	if(!isBlank('담당자메일', '#business_mail2'))
	if(!isBlank('연구자이름', '#researcher_nm'))
	if(!isBlank('연구자전화번호', '#researcher_tel1'))
	if(!isBlank('연구자전화번호', '#researcher_tel2'))
	if(!isBlank('연구자전화번호', '#researcher_tel3'))
	if(!isBlank('연구자메일', '#researcher_mail1'))	
   	if(!isBlank('연구자메일', '#researcher_mail2')){
		$.ajax({
		   url : "/techtalk/doSetUpdateX.do",
	       type: "post",
	       data: {
	    	   researcher_seqno : r_seqno,
	    	   demand_seqno : d_seqno,
	    	   match_date : match_date,
	    	   contents : contents,
	    	   business_nm : business_nm,
	    	   business_tel : business_tel,
	    	   business_mail : business_mail,
	    	   researcher_nm : researcher_nm,
	    	   researcher_tel : researcher_tel,
	    	   researcher_mail : researcher_mail
	       	},
	       dataType: "json",
	       success : function(res){
	    	   alert('매칭 이력을 저장하였습니다.');
	    	   historyClick(d_seqno, r_seqno)   
	       },
	       error : function(){
	    	alert('실패했습니다.');    
	       },
	       async:false,
	       complete : function(){
	
	       }
		});
   	}
}
</script>
<!-- compaVcContent s:  -->
<!--  
<form action="/techtalk/doMatchHistoryList.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="match_seqno" name="match_seqno" value=""/>
</form>
-->
<form action="#" id="frm" name="frm" method="post">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="rows" id="rows" value="${paraMap.rows}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<input type="hidden" name="list" id="list" />
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">		
			<div class="area_cont">
				<div class="area_tit">
					<h3 class="tit_corp">매칭된 연구자-기업수요 목록</h3>
					<div class="belong_box">
		                <dl class="belong_box_inner">
		                    <dt>소속</dt>
		                    <dd>${dataTLO[0].biz_name}</dd>
		                </dl>
		            </div>
				</div>
				<div class="list_panel">
		        	<div class="cont_list">
		        		<div class="list_top">
							<p>count : ${totalCount}건</p>
							<div class="list_top_util ">
								<div class="search_box_inner">
									<div class="btn_box">
										<button type="button" class="btn_default"  title="필터" id="filterBtn">
											<i class="icon_filter"></i>
											<span>필터</span>
										</button>
									</div>
									<div class="search_keyword_box">
										<input type="text" class="keyword_input" id="keyword" name="keyword" value="${paraMap.keyword}" placeholder="키워드를 입력하세요." value="" title="검색어">
									</div>
									<div class="btn_wrap">
										<button type="button" class="btn_step" onClick="javascript:doSearch();" title="검색">
											<span>검색</span>
										</button>
									</div>
									<div class="btn_box btn_box2">
										<c:choose>
											<c:when test="${paraMap.list eq 'all'}">
												<button type="button" id="save" class="btn_point" onClick="javascript:doSave();" title="저장">
													<span>저장</span>
												</button>
												<button type="button" id="cancel" class="btn_default" onClick="javascript:doCancel();" title="취소">
													<span>취소</span>
												</button>
											</c:when>
											<c:otherwise>
												<button type="button" class="btn_default" title="목록관리" onClick="javascript:doListAll();">
													<span>목록관리</span>
												</button>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</div>
		            	<c:choose>
		                	<c:when test="${ not empty dataTLO }">
		                    	<c:forEach var="dataTLO" items="${ dataTLO }">
		                    		<div class="row col-box">
		                    		<c:if test="${paraMap.list eq 'all'}">
			                    		<span class="box_checkinp">
						            		<input type="checkbox" class="inp_check" value="${dataTLO.view_yn}" id="${dataTLO.researcher_seqno}" name="chk" title="표출유무" <c:if test="${dataTLO.view_yn eq 'Y'}">checked</c:if>>
						                </span>
					                </c:if>
				                    	<div class="col">
				                        	<span class="row_txt_num blind">${ dataTLO.length }</span>
				                            <span class="txt_left row_txt_tit txt_line txt_ellip ">${ dataTLO.tech_nm}</span>
				                            <span class="update_date">최근 업데이트 일자 : ${ dataTLO.rupdate}</span>
				                            <ul class="tag_box">
				                            	<c:set var="originalString" value="${dataTLO.bkwd}" />
												<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
												<c:forEach var="item" items="${splitArray}">
													<li>#<c:out value="${item}" /></li>
												</c:forEach>
				                            </ul>
				                            <ul class="step_tech">
				                            	<li><span class="mr txt_grey tech_nm ">${ dataTLO.bcode_name1}</span></li>
				                                <li><span class="mr txt_grey tech_nm ">${ dataTLO.bcode_name2}</span></li>
				                                <li><span class="mr txt_grey tech_nm ">${ dataTLO.bcode_name3}</span></li>
				                            </ul>
				                        </div>
				                        <span class="arrow"></span>
				                        <div class="col">
		                    				<span class="row_txt_num blind">${ dataTLO.length }</span>
		                    				<span class="txt_left row_txt_tit">${ dataTLO.researcher_nm} 연구자 </span>
				                            <span class="re_beloong">${dataTLO.biz_name }</span>
				                            <span class="update_date">최근 출원일 : ${dataTLO.applicant_date}</span>
				                            <ul class="tag_box">
					                        	<c:set var="originalString" value="${dataTLO.rkwd}" />
												<c:set var="splitArray" value="${fn:split(originalString, ',')}" />
												<c:forEach var="item" items="${splitArray}">
												    <li>#<c:out value="${item}" /></li>
												</c:forEach>
				                            </ul>
				                            <ul class="step_tech">
				                            	<li><span class="mr txt_grey tech_nm ">${ dataTLO.rcode_name1}</span></li>
				                                <li><span class="mr txt_grey tech_nm ">${ dataTLO.rcode_name2}</span></li>
				                                <li><span class="mr txt_grey tech_nm ">${ dataTLO.rcode_name3}</span></li>
				                            </ul>
		                    			</div>
				                    	<button type="button" class="history_btn" ><span><a href="javascript:void(0);" onclick="historyClick('${ dataTLO.demand_seqno}','${ dataTLO.researcher_seqno}')">이력보기</a></span></button>
		                    		</div>
		                    	</c:forEach>                        
		                    </c:when>
		                    <c:otherwise>
		                    	<div class="empty_data">
		                        	<p>아직 매칭된 연구자-기업수요가 없습니다.</p>
		                        </div>
		                   	</c:otherwise>
		                </c:choose>
		         	    <div class="tbl_public" id="tbl">
		                </div>
					</div>
					<div class="btn_wrap d-flex ju_be">
						<div class="f_left">
							<button type="button" class="btn_default" id="updateRow" name="updateRow" style="display: none;" onClick="javascript:doUpdateRow();" title="행추가">
								<span>+ 행 추가</span>
							</button>
							<button type="button" class="btn_default" id="deleteRow" name="deleteRow" style="display: none;" onClick="javascript:doDeleteRow();" title="행삭제">
								<span>- 행 삭제</span>
							</button>
						</div>
						<div class="f_right">
							<button type="button" class="btn_step" id="setCancel" name="setCancel" style="display: none;" onClick="javascript:doSetCancel();" title="취소">
								<span>취소</span>
							</button>
							<button type="button" class="btn_step" id="setUpdate" name="setUpdate" style=" display: none;" onClick="javascript:doSetUpdate();" title="저장">
								<span>저장</span>
							</button>
							<button type="button" class="btn_step" id="set" name="set" style="display: none;" onClick="javascript:doSet();" title="수정">
								<span>수정</span>
							</button>
						</div>
					</div>
				</div>
				<!-- paging -->
				<div class="paging_comm">${sPageInfo}</div>
			</div>
		</div>
	</div>
</div>
</form>
<form action="#" id="frm2" name="frm2" method="post">
<div class="dim-layer filterPop" >
    <div class="dimBg"></div>
    <div id="filterPop" class="pop-layer" style="height:420px;width:640px">
        <div class="pop-container">
        <div class="pop-title"><h3>필터</h3><button class="btn-layerClose" title="팝업닫기"><span class="icon ico_close">팝업닫기</span></button></div>
            <div id="tap1_1" style="display: block">
				<div class="tbl_view tbl_public tr_tran" style="margin-top:0">
					<table class="tbl">
						<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">필터</caption>
						<colgroup>
							<col style="width:150px"/><col />
						</colgroup>
						<thead></thead>
						<tbody class="line">
							<tr>
								<th scope="col">최근 업데이트 일자</th>
								<td class="left form-inline">
									<div class="btn_chk div-inline">
										<input type="checkbox" name="date_all"  id="date_all" value="date_all"> 
										<label for="date_all" class="option_label">  
											<span class="inner"><span class="txt_checked">전체</span></span> 
										</label>
									</div>
									<div class="datepicker_wrap">
										<input type="text" id="strDate" name="strDate" class="form-control">
										~
										<input type="text" id="endDate" name="endDate" class="form-control">
									</div>
									
								</td>
							</tr>
							<tr>
								<th scope="col">최근 출원일</th>
								<td class="left form-inline">
									<div class="btn_chk div-inline">
										<input type="checkbox" name="date_all2"  id="date_all2" value="date_all2"> 
										<label for="date_all2" class="option_label">  
											<span class="inner"><span class="txt_checked">전체</span></span> 
										</label>
									</div>
									<div class="datepicker_wrap">
										<input type="text" id="strDate2" name="strDate2" class="form-control">
										~
										<input type="text" id="endDate2" name="endDate2" class="form-control">
									</div>
									
								</td>
							</tr>
							<tr>
								<th scope="col">기술분야</th>
								<td class="left form-inline">
									<div class="btn_chk div-inline">
										<input type="checkbox" name="tech_field"  id="tech_all" value="tech_all"> 
										<label for="tech_all" class="option_label">  
											<span class="inner"><span class="txt_checked">전체</span></span> 
										</label>
									</div>
									<select id="filterStdClassCd1" name="filterStdClassCd1" onChange="filterChangeStd(this, 'mid');" title="기술분류1" style="width: 25%;">
										<option title="기술분류1" value="">선택</option>
										<c:forEach var="data" items="${codeList1}" varStatus="status">
											<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option> 
										</c:forEach>
									</select>
									<select id="filterStdClassCd2" name="filterStdClassCd2" disabled onChange="filterChangeStd(this, 'sub');" title="기술분류2" style="width: 25%;">
										<option title="기술분류2" value="">선택</option>
										<c:forEach var="data" items="${codeList2}" varStatus="status">
											<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option> 
										</c:forEach>
									</select>
									<select id="filterStdClassCd3" name="filterStdClassCd3" disabled title="기술분류3" style="width: 25%;">
										<option title="기술분류3" value="">선택</option>
										<c:forEach var="data" items="${codeList3}" varStatus="status">
											<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
					<div class="tbl_public" >
						<div style="text-align:center;margin-top:40px;">
		                	<button type="button" class="btn_step btn_point_black" onClick="javascript:doSearchFilter();"  title="적용">적용</button>
		                	<button type="button" class="btn_line btn_cancel" id="cancelId"  name="btnCancel" title="닫기">닫기</button>
	                	</div>
	                </div>
				</div>
			</div>
        </div>
   	</div>
</div>
</form>