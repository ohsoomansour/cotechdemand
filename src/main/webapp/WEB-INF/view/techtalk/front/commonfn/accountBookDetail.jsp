<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link rel="stylesheet"
	href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css?v=1"
	type="text/css" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js?v=1"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/js/jquery.mask.js?v=1"></script>
<!-- 업로더 -->
<script
	src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script
	src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1">
<script>
window.onload = function(){
}
$(document).ready(function () {
	  $.datepicker.setDefaults($.datepicker.regional['ko']);
	  $('#subject_proc_date').inputmask('9999-99-99');
      $( "#subject_proc_date" ).datepicker({
           changeMonth: true, 
           changeYear: true,
           nextText: '다음 달',
           prevText: '이전 달', 
           dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
           dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
           monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
           monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
           dateFormat: "yy-mm-dd",
           beforeShow: function() {
               setTimeout(function(){
                   $('.ui-datepicker').css('z-index', 9999);
               }, 0);
           },
           //maxDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이후 날짜 선택 불가)
           onClose: function( selectedDate ) {    
                //시작일(startDate) datepicker가 닫힐때
                //종료일(endDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
               //$("#endDate").datepicker( "option", "minDate", selectedDate );
           }    

      });
});
function layer_popup(el,check){
	console.log('i값은?',check)
	if(check !='x'){
		var i= check*1;
		var item = $('#item_item'+i).text();
		var date = $('#item_date'+i).text();
		var cost = $('#item_cost'+i).text();
		var desc = $('#item_desc'+i).text();
		var seqno = $('#item_seqno'+i).val();
		console.log("item",item,"date",date,"cost",cost,"desc",desc,"seqno",seqno);
		$('#item').val(item);
		$('#subject_proc_date').val(date);
		$('#cost').val(cost);
		$('#purpose').val(desc);
		$('#seqno').val(seqno);
		}

    var $el = $(el);    //레이어의 id를 $el 변수에 저장
    var $ep = $(el);
    var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

    isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();
	setTimeout(function(){
		$('.pop-container').focus();
   	}, 500);
	$('#skip_navigation').find("input, a, button").attr('tabindex','-1');
	$('#compaVcHead').find("input, a, button").attr('tabindex','-1');
	$('#compaVcContent').find("input, a, button").attr('tabindex','-1');
	$('.scroll-top fixed').find("input, a, button").attr('tabindex','-1');
	$('#compaVcFoot').find("input, a, button").attr('tabindex','-1');
    
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
        	$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
        	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
        	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
        	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
        	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        	setTimeout(function(){
        		$('#addDetail'+check).focus();
           	}, 500);
            return false;
        }
    });

    $el.find('.btn-layerClose').click(function(){
        isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#item').val("");
        $('#cost').val("");
        $('#purpose').val("");
        $('#subject_proc_date').val("");
        $('#seqno').val("");
        $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
    	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	setTimeout(function(){
    		$('#addDetail'+check).focus();
       	}, 500);
        return false;
    });
    $el.find('#closelayer').click(function(){
        isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#item').val("");
	    $('#cost').val("");
	    $('#purpose').val("");
	    $('#subject_proc_date').val("");
	    $('#seqno').val("");
	    $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
    	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	setTimeout(function(){
    		$('#addDetail'+check).focus();
       	}, 500);
        return false;
    });
    
    $('.layer .dimBg').click(function(){
    	$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
    	$('.scroll-top fixed').find("input, a, button").removeAttr('tabindex');
    	$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	setTimeout(function(){
    		$('#addDetail'+check).focus();
       	}, 500);
        $('.dim-layer').fadeOut();
        return false;
    });

}  
function getHist(subject_seqno,settle_seqno){
	console.log("드러오냐",subject_seqno,settle_seqno)
	var url = "/front/doAccountBookHist.do"
	var form = $('#frm2')[0];
	var data = new FormData(form);
	data.append("settle_seqno",settle_seqno);
	console.log("나오니",form);
	$.ajax({
	       url : url,
	       type: "post",
	       processData: false,
	       contentType: false,
	       data: data,
	       dataType: "json",
	       success : function(res){
		        $('#settle_seqno').val(settle_seqno);
	       		$('#detail').css('display','block');
	       		$('#detailbtn').css('display','block');
	       		var ahtml= "";
	       		if(res.result[0].subject_proc_date == undefined){
		       		ahtml += "<tr>"
		       		ahtml += "<td colspan='5'>"
		       		ahtml += "세부내역이 존재하지 않습니다."
		       		ahtml += "</td>"
		       		ahtml += "</tr>"
		       		}
	       		else{
	       			for(var i=0; i<res.result.length;i++){
		       			var date = res.result[i].subject_proc_date;
		       			date = date.substring(0,10);
       					ahtml +="<tr>"
       					ahtml +=	"<td ><span id='item_date"+i+"'>"+date+"</span></td>"
       					ahtml +=	"<td><span id='item_item"+i+"'>"+res.result[i].item+"</span></td>"
       					ahtml +="<td><span id='item_desc"+i+"'>"+res.result[i].purpose+"</span></td>"
       					ahtml +=	"<td><span id='item_cost"+i+"'>"+res.result[i].cost+"<span></td>"
       					ahtml += "<input type='hidden' id='item_seqno"+i+"' value='"+res.result[i].seqno+"' />'"
       					ahtml +=	"<td>"
       					ahtml +=		"<a class='btn_step' onclick=layer_popup('#layer2',"+i+") id='addDetail"+i+"' tabindex='0' href='javascript:void(0);' title='사업비 집행내역 추가하기'>"
       					ahtml +=			"[상세보기]"
       					ahtml +=		"</a>"
       					ahtml +=	"</td>"
       					ahtml +="</tr>"
	       				}
		       		}
	       		$('#AccountBookDetail').empty();
	       		$('#AccountBookDetail').append(ahtml);
			       	
	       	console.log("결과",res);   
	       },
	       error : function(){
	    	   alert('게시판 등록에 실패했습니다.');    
	       },
	       complete : function(){
		       
	       	//parent.fncList();
	       	//parent.$("#dialog").dialog("close");
	       }
	});  	
}

function addHist(i){
	var url = "/front/accountBookSubmit.do";
	var form = $('#frm3')[0];
	var data = new FormData(form);
	var subject_seqno = $('#subject_seqno').val();
	data.append("subject_seqno",subject_seqno);
	
	var itemVal = $('#item').val();
	var subjectProcDateVal = $('#subject_proc_date').val();
	var costVal = $('#cost').val();
	var purposeVal = $('#purpose').val();
	
	if(itemVal == "" || itemVal == null || itemVal == undefined ){
		alert_popup_focus("세목을 입력해주세요.", '#item');
		return false;
	}else if(subjectProcDateVal == "" || subjectProcDateVal == null || subjectProcDateVal == undefined ){
		alert_popup_focus("사용일자를 입력해주세요.", '#subject_proc_date');
		return false;
	}else if(costVal == "" || costVal == null || costVal == undefined ){
		alert_popup_focus("사용금액을 입력해주세요.", '#cost');
		return false;
	}else if(purposeVal == "" || purposeVal == null || purposeVal == undefined ){
		alert_popup_focus("사용목적을 입력해주세요.", '#purpose');
		return false;
	}else{
		$.ajax({
		       url : url,
		       type: "post",
		       processData: false,
		       contentType: false,
		       data: data,
		       dataType: "json",
		       success : function(res){
			     if(res.result !=0){
				     $('#item').val("");
				     $('#cost').val("");
				     $('#purpose').val("");
				     $('#subject_proc_date').val("");
				     var action="/front/accountBookDetail.do"
	    		   	 var form = document.createElement('form');
	    		   	 form.setAttribute('method', 'post');
	    		   	 form.setAttribute('action', action);
	    		   	 document.charset = "utf-8";

	    			 var hiddenField = document.createElement('input');
	    			 hiddenField.setAttribute('type', 'hidden');
	    			 hiddenField.setAttribute('name', 'project_seqno');
	    			 hiddenField.setAttribute('value', '${ paraMap.project_seqno}');

	    			 var hiddenField2 = document.createElement('input');
	    			 hiddenField2.setAttribute('type', 'hidden');
	    			 hiddenField2.setAttribute('name', 'subject_seqno');
	    			 hiddenField2.setAttribute('value', '${ paraMap.subject_seqno}');
	    			
	    			 form.appendChild(hiddenField);
	    			 form.appendChild(hiddenField2);
	    		   	 document.body.appendChild(form);
	    		   	
			    	 alert_popup("추가되었습니다",undefined,form);
				     }
		       	console.log("결과",res);   
		       },
		       error : function(){
		    	   alert_popup('게시판 등록에 실패했습니다.');    
		       },
		       complete : function(){
			       
		       }
		});  
	}
}
</script>
<form name="frm2" id="frm2" action="/admin/doAccountBookHist.do" method="post">
	<input type="hidden" name="subject_seqno" id="subject_seqno" value="${paraMap.subject_seqno }"/>
</form>
<form name="frm" id="frm" action="/front/accountBookList.do" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno" value="${paraMap.project_seqno} " /> 
	<input type="hidden" name="vat_cost" id="vat_cost" value="${paraMap.vat_cost} " />
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<h3 class="tit_corp">사업비 집행내역 상세정보</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<h4 class="subject_corp">과제정보</h4>
					<div class="box_info2">
						<dl>
							<dt>협약번호</dt>
							<dd>${paraMap.subject_ref }</dd>
						</dl>
						<dl>
							<dt>사업명</dt>
							<dd >${paraMap.project_title }</dd>
						</dl>
						<dl>
							<dt>과제명</dt>
							<dd>${paraMap.subject_title }</dd>
						</dl>
						<dl class="col4">
							<dt>수요기업</dt>
							<dd>${paraMap.dcdata.biz_name}</dd>
							<dt>공급기업</dt>
							<dd>${paraMap.scdata.biz_name}</dd>
						</dl>
						<dl class="col4">
							<dt>협약기간</dt>
							<dd>2021.03.01 ~ 2021.12.31</dd>
							<dt>진행상태</dt>
							<dd>
								<span class="lb lb_apply">협약체결</span>
							</dd>
						</dl>
					</div>

				</div>
				
				<div class="area_cont area_cont2">
					<div class="subject_corp">
						<h4>세목별 사업비 집행현황</h4>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">사업공통 세목별 사업비 집행현황</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col style="width: 200px;" />
								<col style="width: 280px;" />
								<col style="width: 100px;" />
								<col style="width: 100px;" />
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th>세목</th>
									<th>협약예산(A)</th>
									<th>집행금액(B)</th>
									<th>사용잔액(C)</th>
									<th>집행률(%)</th>
									<th>상세보기</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>총계</td>
									<td>${paraMap.total.cost}</td>
									<td>${paraMap.total.use_cost}</td>
									<td>${paraMap.total.remaining}</td>
									<td>${fn:substring(paraMap.total.use_rate,0,4) } %</td>
									<td>
									-
									</td>
								</tr>
								<c:forEach var="list" items="${paraMap.accountbookdata}" varStatus="status">
									<tr>
										<td>${list.item}</td>
										<td>${list.cost }</td>
										<td>${list.use_cost}</td>
										<td>${list.cost - list.use_cost}</td>
										<td>${list.use_rate }
										
											${fn:substring(data.use_rate,0,4) } %
										
										</td>
										<td>
											<a href="javascript:void(0);" class="btn_step" onclick="getHist('${list.subject_seqno}','${list.settle_seqno}')" title="세목별 사업비 상세보기">
												상세보기
											</a>
										</td>
									</tr>
								</c:forEach>
								<c:if test="${empty paraMap.accountbookdata}" >
									<tr>
										<td colspan="6">
											세목별 사업비 집행현황이 없습니다.
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
				<!-- <div class="area_cont area_cont2" > -->
				<div class="area_cont area_cont2" id="detail" style="display:none;">
					<div class="subject_corp">
						<h4>사업비 집행현황 세부내역</h4>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">사업공통 사업비 집행현황 세부내역</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col style="width: 200px;" />
								<col style="width: 200px;" />
								<col style="width: 280px;" />
								<col style="width: 100px;" />
							</colgroup>
							<thead>
								<tr>
									<th>사용일자</th>
									<th>세목</th>
									<th>사용목적</th>
									<th>집행금액</th>
									<th>상세보기</th>
								</tr>
							</thead>
							<tbody id="AccountBookDetail">
							</tbody>
						</table>
					</div>
				</div>
				<div class="wrap_btn _center" id="detailbtn" style="display:none;">
					<a href="javascript:void(0);" class="btn_appl" onclick="layer_popup('#layer2','x')" title="세부내역 추가하기" id="addDetailx">세부내역 추가하기</a>
				</div>
				<div class="wrap_btn _center">
					<a href="/front/accountBookList.do"  class="btn_list" title="목록으로 이동">목록으로 이동</a>
				</div>
				<!-- //page_content e:  -->
			</div>
		</div>
	</div>
</form>

	<!-- 세부내역추가/수정 popup -->
<form id="frm3" name="frm3" action="/front/accountBookSubmit.do" method="post">
<input type="hidden" id="seqno" name="seqno" value="" />
<input type="hidden" id="settle_seqno" name="settle_seqno" value="" />
<div class="dim-layer">
   <div class="dimBg"></div>
   <div id="layer2" class="pop-layer" style="height:400px">
       <div class="pop-container">
	       <div class="pop-title">
	           <h3>사업비 집행내역</h3>
	       </div>
           <div class="pop-conts" style="text-align:right;">
           	<span id="list_size"></span>
              <div style="height:250px">
               <div class="tbl_comm tbl_public" style="margin-top:10px">
					<table class="tbl">
						<caption class="caption_hide">사업공통 사업비 집행내역</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 200px;" />
						</colgroup>
						<tbody id="AccountBookAdd">
							<tr>
								<th>세목</th>
								<td><input type="text" id="item" name="item" title="세목"/></td>
							</tr>
							<tr>
								<th>사용일자</th>
								<td>
									<!-- <input type="text" id="subject_proc_date"/> -->
									<input type="text" id="subject_proc_date" name = "subject_proc_date" style="float:left" title="사용일자" data-inputmask="'alias': 'date'"/>  
								</td>
							</tr>
							<tr>
								<th>사용금액</th>
								<td><input type="text" id="cost" name="cost" title="사용금액"/></td>
							</tr>
							<tr>
								<th>사용목적</th>
								<td><input type="text" id="purpose" name="purpose" title="사용목적"/></td>
							</tr>
						</tbody>
					</table>
				</div>
               <div style="text-align:center;margin-top:10px;">
				<button type="button" onClick="addHist();" class="btn_step" title="추가/수정">추가 / 수정</button>
				<button type="button" class="btn_step" id="closelayer" title="닫기">닫기</button>
				</div>
               <!--// content-->
           </div>
       </div>
   	</div>
</div>
</div>
</form>