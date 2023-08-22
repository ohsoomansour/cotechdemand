<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css?v=1" type="text/css" />  
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js?v=1"></script>  
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js?v=1"></script>
 -->
<!-- 업로더 -->
<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1" />

<script>
var selectData ;
var radioSelect = 0;
var before_btn = '.btn_list';
window.onload = function(){
	var list = new Array();
	<c:forEach items="${code}" var="list">
		var item ={};
		item.text = "${list.doc_name}";
		item.value = "${list.value}";
		item.isRequired = "false";
		list.push(item);
	</c:forEach>
	//해당부분 추후 db초기화시 삭제 예정
	var etc = {};
	etc.text = '기타'; etc.value='ETC',etc.isRequired="false";
	list.push(etc);
	var ba = {};
	ba.text = '사업신청서'; ba.value='BA',ba.isRequired="false";
	list.push(ba);
	var ma = {};
	ma.text = '매칭신청서'; ma.value='MA',ma.isRequired="false";
	list.push(ma);
	var cc = {};
	cc.text = '기업확인서'; cc.value='CC',cc.isRequired="false";
	list.push(cc);
	//여기까지삭제
	console.log(list);
	 var options = {
    	fmstSeq: 0,
    	//fmstSeq: 11,
        types: list,
        callback: function(data){
        	if(data == 0 || data == undefined){
        		alert("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
		    	return false;
		    	}
	    	doData(data);
		},
    };
    window.uploadSrc.create($('#uploadArea'), options);
    setTimeout(function(){
    	$('#subject_ref').focus();
    }, 500);
}

//유효성체크
function validataCheck(stat,btn){
	console.log("??")
	before_btn = btn;
	status = stat;
	//null체크 후 
	if(!isBlank('성명', '#dc_pic1_name'))
	if(!isBlank('직급(직위)', '#dc_pic1_rank'))
	if(!isBlank('소속부서', '#dc_pic1_depart'))
	if(!isBlank('전공', '#dc_pic1_major'))
	if(!isBlank('전화', '#dc_pic1_tel_no'))
	if(!isBlank('E-mail', '#dc_pic1_email'))
	if(!isBlank('휴대전화', '#dc_pic1_mobile_no'))
	if(!isBlank('성명', '#dc_pic2_name'))
	if(!isBlank('직급(직위)', '#dc_pic2_rank'))
	if(!isBlank('소속부서', '#dc_pic2_depart'))
	if(!isBlank('전공', '#dc_pic2_major'))
	if(!isBlank('전화', '#dc_pic2_tel_no'))
	if(!isBlank('E-mail', '#dc_pic2_email'))
	if(!isBlank('휴대전화', '#dc_pic2_mobile_no'))
	if(!isBlank('성명', '#sc_pic1_name'))
	if(!isBlank('직급(직위)', '#sc_pic1_rank'))
	if(!isBlank('소속부서', '#sc_pic1_depart'))
	if(!isBlank('전공', '#sc_pic1_major'))
	if(!isBlank('전화', '#sc_pic1_tel_no'))
	if(!isBlank('E-mail', '#sc_pic1_email'))
	if(!isBlank('휴대전화', '#sc_pic1_mobile_no'))
	if(!isBlank('성명', '#sc_pic2_name'))
	if(!isBlank('직급(직위)', '#sc_pic2_rank'))
	if(!isBlank('소속부서', '#sc_pic2_depart'))
	if(!isBlank('전공', '#sc_pic2_major'))
	if(!isBlank('전화', '#sc_pic2_tel_no'))
	if(!isBlank('E-mail', '#sc_pic2_email'))
	if(!isBlank('휴대전화', '#sc_pic2_mobile_no'))
	if(!isBlank('성능평가 인증', '#bs10'))
	if(!isBlank('인허가 컨설팅', '#bs20'))
	if(!isBlank('IP 관리 컨설팅', '#bs30'))
	if(!isBlank('사업화 컨설팅', '#bs40'))
	if(!isBlank('신기술(신제품)개발 R&D 지원', '#ts10'))
	if(!isBlank('기존기술(기존제품)개선 R&D 지원', '#ts20'))
	if(!isBlank('시작품 제작 지원', '#ts30'))
	if(!isBlank('정부출연금', '#gov_cost'))
	if(!isBlank('수요기업 지부담금', '#com_cost')){
		var check = confirm("작성하신 사업계획서를 저장하시겠습니까? ")
			if (check == true) {
				uploadFile()
			}
	}
}
function uploadFile(){
	var empty = document.getElementsByClassName('file-empty')[0];
	if(empty==undefined){
		//파일전송후 공고등록
		uploadSrc.startUpload();
	}
	else{
		//alert("")
		//공고등록
		doData();
	}
}

function doData(fmstSeqno) {
	$('input').attr('disabled',false);
	
	var url = "/subject/applySubmit.do";
	var form = $('#frm')[0];
	var data = new FormData(form);
	if(fmstSeqno != undefined){
		data.append("fmst_seqno",fmstSeqno);
		}
	data.append("subject_proc_status",status);
	$.ajax({
	       url : url,
	       type: "post",
	       processData: false,
	       contentType: false,
	       data: data,
	       dataType: "json",
	       success : function(res){
	       	//alert('신청 되었습니다',res);
	       	//window.location.href = "/admin/projectapply/list.do?offset=1&limit=10";
       		window.open("https://www.one-click.co.kr/cm/CM0100M001GE.nice?cporcd=280&pdt_seq=1","_blank");
	       	console.log("결과",res);   
	       	//window.location.href="/subject/documentCheck.do";
	       	//$('#frm2').submit();
	       	documentCheckSubmit(res.paraMap);
	       },
	       error : function(){
	    	  alert('게시판 등록에 실패했습니다.');    
	       },
	       complete : function(){
	    	 $('input').attr('disabled',true);
	       	//parent.fncList();
	       	//parent.$("#dialog").dialog("close");
	       }
	}); 
}

function documentCheckSubmit(subject_seqno){
	var project_seqno = $('#project_seqno').val();
	
	var newForm = document.createElement('form'); 
	// set attribute (form) 
	newForm.name = 'frm2'; 
	newForm.method = 'post'; 
	newForm.action = '/subject/documentCheck.do'; 
	// create element (input) 
	var input1 = document.createElement('input'); 
	// set attribute (input) 
	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "project_seqno"); 
	input1.setAttribute("value", project_seqno);

	var input2 = document.createElement('input');  
	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "subject_seqno"); 
	input1.setAttribute("value", subject_seqno);
	// append input (to form) 
	newForm.appendChild(input1); 
	newForm.appendChild(input2); 
	// append form (to body) 
	document.body.appendChild(newForm); 
	// submit form 
	newForm.submit();

	}

$(document).ready(function () {
	$.datepicker.setDefaults($.datepicker.regional['ko']); 
    $( "#subject_sdate" ).datepicker({
         changeMonth: true, 
         changeYear: true,
         nextText: '다음 달',
         prevText: '이전 달', 
         dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
         dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
         monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         dateFormat: "yy-mm-dd",
         //maxDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이후 날짜 선택 불가)
         onClose: function( selectedDate ) {    
              //시작일(startDate) datepicker가 닫힐때
              //종료일(endDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
             $("#subject_edate").datepicker( "option", "minDate", selectedDate );
             setTimeout(function(){
            	 $("#subject_edate").focus();
             }, 500);
         }    

    });
    $( "#subject_edate" ).datepicker({
         changeMonth: true, 
         changeYear: true,
         nextText: '다음 달',
         prevText: '이전 달', 
         dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
         dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
         monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         dateFormat: "yy-mm-dd",
         //maxDate: 0,                       // 선택할수있는 최대날짜, ( 0 : 오늘 이후 날짜 선택 불가)
         onClose: function( selectedDate ) {    
             // 종료일(endDate) datepicker가 닫힐때
             // 시작일(startDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 시작일로 지정
             //$("#startDate").datepicker( "option", "maxDate", selectedDate );
             call();
             setTimeout(function(){
            	 $("#subject_term").focus();
             }, 500);
         }    

    }); 
    //sector_lev2 버튼 제어 
    $("input[name=sector_lev2]").click(function(){
		var value = "#"+$(this).val();
		if($(this).is(":checked")==true){
			$(value).removeAttr('disabled');
			}
		else{
			$(value).attr("disabled",true);
			}
		
        })

    //공급기관찾기버튼
    $('.btn-example').click(function(){
   	    var $href = $(this).attr('href');
        var cls = "idCls";
		var op = $(this);
        layer_popup($href, cls, op);
 });
   //공급기관 팝업띄우기
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
	    $('#skip_navigation').find("input, a, button").attr('tabindex','-1');
        $('#compaVcHead').find("input, a, button").attr('tabindex','-1');
        $('#compaVcContent').find("input, a, button").attr('tabindex','-1');
        $('.wrap-loading').find("input, a, button").attr('tabindex','-1');
        $('.scroll-top').find("input, a, button").attr('tabindex','-1');
	    $('#compaVcFoot').find("input, a, button").attr('tabindex','-1');
	
	    //esc키 버튼 입력시 통보 없애기
	    $(document).keydown(function(event) {
	        if ( event.keyCode == 27 || event.which == 27 ) {
	        	 $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
		            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
		            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
		            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
		            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
		    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
	        	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
	        	setTimeout(function(){
	            	$op.focus();
	               }, 500);
	            return false;
	        }
	    });
	    
	    $('#cancelAlert').click(function(){
	        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
	        $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$('#search_sc').focus();
    	    }, 500);
	        
	        return false;
	    });
	    $el.find('.btn-layerClose').click(function(){
	        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
	        $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$('#search_sc').focus();
    	    }, 500);
	        
	        return false;
	    });

	    $('.layer .dimBg').click(function(){
	        $("."+cls).fadeOut();
	        $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$('#search_sc').focus();
    	    }, 500);
	        
	        return false;
	    });

    }  
    //공급기관 찾기 
   var searchApply = document.getElementById("searchApply");
   searchApply.addEventListener("keydown", function (e) {
       if (e.code === "Enter") {  //checks whether the pressed key is "Enter"
       	doSearchApply();
       }
   });
});
//선택한 날짜 개월수 구하기
function call()
{
    var sdd = document.getElementById("subject_sdate").value;
    var edd = document.getElementById("subject_edate").value;
    var ar1 = sdd.split('-');
    var ar2 = edd.split('-');
    var da1 = new Date(ar1[0], ar1[1], ar1[2]);
    var da2 = new Date(ar2[0], ar2[1], ar2[2]);
    var dif = da2 - da1;
    var cDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
    var cMonth = cDay * 30;// 월 만듬
    var cYear = cMonth * 12; // 년 만듬
    
 if(sdd && edd){
   // document.getElementById('years').value = parseInt(dif/cYear)
    document.getElementById('subject_term').value = parseInt(dif/cMonth)
    //document.getElementById('days').value = parseInt(dif/cDay)
 }
}


//공급기관 사업자번호로 검색하기
function doSearchApply(){
	var applyNo = document.getElementById('searchApply').value;
	var ahtml = "";
	$.ajax({
        url : "/subject/searchBiz?biz_regno="+applyNo,
        type: "get",
        data: '',
        dataType: "json",
        success : function(res){
	        //var biz =[];
	        selectData = res.biz;
	       // biz =  res.biz;
	        var size = res.biz_size;
		        ahtml +='<table class="tbl">';
				ahtml +='<caption class="caption_hide">사업신청 기업검색</caption>';
				ahtml +='<colgroup>';
				ahtml +='	<col>';
				ahtml +='	<col style="width: 100px;">';
				ahtml +='</colgroup>';
				ahtml +='<thead>';
				ahtml +='	<tr>';
				ahtml +='		<th>기업명</th>';
				ahtml +='		<th></th>';
				ahtml +='	</tr>';
				ahtml +='</thead>';
				ahtml +='<tbody>';
	        if(size > 0 ){
	        	for(var i=0; i<size; i++){
		        	ahtml+="<tr>";
			        ahtml += "<td>기업명 : "+selectData[i].biz_name + "</td>";
			        ahtml+= "<td><button type='button' class='btn_step' onClick='clickData("+i+")' title='공급기관 기업 선택'>선택</button></td>";
			        ahtml+="</tr>";
	        	 }
	        }else{
	        	ahtml+="<tr>";
		        ahtml += "<td colspan='2'>검색한 사업자번호가 없습니다.</td>";
		        ahtml+="</tr>";
	        }
		   
	        ahtml +'=</tbody>';
	        ahtml +'=</table>';
    		$('#applyData').empty();
    		$('#applyData').append(ahtml); 
        },
        error : function(){
        	alert_popup_focuse('검색 실패하였습니다.','#btn_search_apply');    
        },
        complete : function(){
	        
        }
	}); 
}

function clickData(i){
//alert("선택되었습니다.",biz_seqno);
console.log("선택되었습니다.",i);
console.log("데이터",selectData[i]);
$('#sc_biz_name').val(selectData[i].biz_name);
$('#sc_biz_regno').val(selectData[i].biz_regno);
$('#sc_biz_address').val(selectData[i].address1+selectData[i].address2);
$('#sc_biz_owner').val(selectData[i].owner);
$('#sc_biz_tel_no').val(selectData[i].tel_no);
$('#sc_pic1_name').val(selectData[i].user_name);
$('#sc_pic1_rank').val(selectData[i].user_rank);
$('#sc_pic1_depart').val(selectData[i].user_depart);
$('#sc_pic1_tel_no').val(selectData[i].user_tel_no);
$('#sc_pic1_email').val(selectData[i].user_email);
$('#sc_pic1_mobile_no').val(selectData[i].user_mobile_no);
$('#sc_pic1_fax_no').val(selectData[i].user_fax_no);
$('#sc_member_seqno').val(selectData[i].member_seqno);

$('.dim-layer').fadeOut();
$('#applyData').empty();

$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
$('#compaVcHead').find("input, a, button").removeAttr('tabindex');
$('#compaVcContent').find("input, a, button").removeAttr('tabindex');
$('.wrap-loading').find("input, a, button").removeAttr('tabindex');
$('.scroll-top').find("input, a, button").removeAttr('tabindex');
$('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
setTimeout(function(){
	$('#companyType1').focus();
}, 500);

}
//onchange event totalCost
function totalCost(){
	var gov_cost = $('#gov_cost').val()*1;
	var com_cost = $('#com_cost').val()*1;
	var sum = gov_cost + com_cost;
	$('#total_cost').val(sum);
}
//onchange event vocherCost
function voucherTotal(){
	var bs10 = $('#bs10').val()*1;
	var bs20 = $('#bs20').val()*1;
	var bs30 = $('#bs30').val()*1;
	var bs40 = $('#bs40').val()*1;
	var bs50 = $('#bs50').val()*1;
	var ts10 = $('#ts10').val()*1;
	var ts20 = $('#ts20').val()*1;
	var ts30 = $('#ts30').val()*1;
	var sum = bs10 + bs20 + bs30 + bs40 + bs50 + ts10 + ts20 + ts30 ;
	$('#voucher_total').val(sum); 
	var dc_biz_size = $("input[name='dc_biz_size']:checked").val(); 
	if(dc_biz_size == 'MD0'){
		var fee =  sum*0.05;
		fee = fee.toFixed(1);
	}else if(dc_biz_size == 'MS0'){
		var fee =  sum*0.025;
		fee = fee.toFixed(1);
	}else{
		alert_popup_focus("수요기업의 기업유형을 선택해주세요.",'#company1')		
		return;	
	}
	//총사업비
	var total_cost = sum + (fee*1);
	$('#total_cost').val(total_cost);
	//정부출연금
	var gov_cost = sum;
	$('#gov_cost').val(gov_cost);
	//자부담금
	$('#com_cost').val(fee*1);
	//console.log("totalcost=",total_cost , " sum = " , sum , " fee = " , fee , "gov_cost = ", gov_cost)
}

function test() {
	//var form = $('#frm')[0];
	var form = jQuery('#frm').serialize();
	//var data = new FormData(form);
	//console.log("data",data);
	console.log("form",form)
}

 function goList(){
	 window.location.href="/subject/applyFin.do?status=submit"
	}
</script>
<form action="/subject/documentCheck.do" id="frm2" name="frm2" method="post">
</form>
<!-- compaVcContent s:  -->
			<div id="compaVcContent" class="cont_cv">
				<div id="mArticle" class="assig_app">
					<h2 class="screen_out">본문영역</h2>
					<div class="wrap_cont">
                        <!-- page_title s:  -->
						<div class="area_tit">
							<h3 class="tit_corp">
								<c:if test="${ paraMap.status_apply eq 'reg' || paraMap.status_apply eq 'save' || paraMap.status_apply eq ''}" >
									사업신청서 신규작성
								</c:if>
								<c:if test="${ paraMap.status_apply eq 'upd' }" >
									사업신청서 상세정보
								</c:if>
							</h3>
						</div>
						<!-- //page_title e:  -->
						<!-- page_content s:  -->
						<div class="area_cont">
							<div class="w_top">
								<h4 class="subject_corp">바우처사업관리시스템 사업 신청서</h4>
                            	<p class="es">* 표시는 필수 입력 사항입니다.</p>
                            </div>
                            
							<div class="tbl_view tbl_public  tbl_public2">
							<form name="frm" id="frm" action = "#" method = "post" >
								<input type="hidden" name="project_seqno" id="project_seqno" value="${paraMap.project_seqno } " />
								<input type="hidden" name="subject_seqno" id="subject_seqno" value="${paraMap.subject_seqno } " />
								<input type="hidden" name="status_apply" id="status_apply" value ="${paraMap.status_apply }" />
								<input type="hidden" name="member_role" id="member_role" value ="DC" />
								<table class="tbl">
									<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">사업신청</caption>
									<colgroup>
                                        <col style="width:80px">
                                        <col style="width:120px">
                                        <col style="width:120px">
                                        <col style="width:120px">
                                        <col>
                                        <col style="width:120px">
                                        <col>
                                    </colgroup>
                                    <thead></thead>
									<tbody>
										<tr>
											<th scope="col" colspan="2">협약 번호</th>
											<td colspan="5">
											<c:if test="${ paraMap.status_apply eq 'reg' || paraMap.status_apply eq 'save' || paraMap.status_apply eq ''}" >
												<input type="text" name="subject_ref" id="subject_ref" placeholder="협약번호를 입력하세요" style="width:100%" title="협약번호" value="${paraMap.subject_ref }" />
											</c:if>
											<c:if test="${ paraMap.status_apply eq 'upd' }" >
												<input type="text" name="subject_ref" id="subject_ref" placeholder="협약번호를 입력하세요" style="width:100%" title="협약번호" value="${paraMap.subject_ref }" />
											</c:if>
											</td>
										</tr>
										<tr>
											<th scope="col" colspan="2">사업명</th>
											<td colspan="5">
											<c:if test="${ paraMap.status_apply eq 'reg' || paraMap.status_apply eq 'save' || paraMap.status_apply eq ''}" >
												<input type="text" name="project_title" id="project_title" placeholder="사업명을 입력하세요" style="width:100%" title="사업명" value="${paraMap.project_title }" disabled="disabled"/>
											</c:if>
											<c:if test="${ paraMap.status_apply eq 'upd' }" >
												<input type="text" name="project_title" id="project_title" placeholder="사업명을 입력하세요" style="width:100%" title="사업명" value="${paraMap.project_title }" disabled="disabled"/>
											</c:if>
												
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="4">분야</th>
											<th scope="col">지원분야</th>
											<td colspan="5" class="ta_left">
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev1"   id="area1" value="BS" title="사업화지원"/>
													<label for="area1" class="lab_check" title="사업화지원"><span class="icon ico_check"></span>사업화지원</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev1"   id="area2" value="TS" title="기술개발지원"/>
													<label for="area2" class="lab_check" title="기술개발지원"><span class="icon ico_check"></span>기술개발지원</label>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="2">상세서비스</th>
											<th scope="col">사업화지원</th>
											<td colspan="4" class="ta_left">
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev2"   id="support1" value="bs10" title="성능평가 인증">
													<label for="support1" class="lab_check" title="성능평가 인증"><span class="icon ico_check"></span>성능평가 인증</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check"  name = "sector_lev2" id="support2" value="bs20" title="인허가 컨설팅">
													<label for="support2" class="lab_check" title="인허가 컨설팅"><span class="icon ico_check"></span>인허가 컨설팅</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev2"   id="support3" value="bs30" title="IP 관리 컨설팅">
													<label for="support3" class="lab_check" title="IP 관리 컨설팅"><span class="icon ico_check"></span>IP 관리 컨설팅</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name = "sector_lev2" id="support4" value="bs40" title="사업화 컨설팅A">
													<label for="support4" class="lab_check" title="사업화 컨설팅A"><span class="icon ico_check"></span>사업화 컨설팅A</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name = "sector_lev2" id="support5" value="bs50" title="사업화 컨설팅B">
													<label for="support5" class="lab_check" title="사업화 컨설팅B"><span class="icon ico_check"></span>사업화 컨설팅B</label>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="col">기술개발지원</th>
											<td colspan="4" class="ta_left">
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev2"   id="technology1" name = "commercialization" value="ts10" title="신기술(신제품)개발 R&D 지원">
													<label for="technology1" class="lab_check" title="신기술(신제품)개발 R&D 지원"><span class="icon ico_check"></span>신기술(신제품) 개발 R&amp;D 지원</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev2"   id="technology2" name = "commercialization" value="ts20" title="기존기술(기존제품)개선 R&D 지원">
													<label for="technology2" class="lab_check" title="기존기술(기존제품)개선 R&D 지원"><span class="icon ico_check"></span>기존기술(기존제품) 개선 R&amp;D 지원</label>
												</div>
												<div class="box_checkinp">
													<input type="checkbox" class="inp_check" name="sector_lev2"   id="technology3" name = "commercialization" value="ts30" title="시제품 제작 지원">
													<label for="technology3" class="lab_check" title="시제품 제작 지원"><span class="icon ico_check"></span>시제품 제작 지원</label>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="col">탄소중립<br>해당여부</th>
											<td colspan="5" class="ta_left">
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon1"  value="SL" title="태양광">
											        <label for="carbon1" class="lab_check" title="태양광"><span class="icon ico_check"></span>태양광</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon2"  value="WP"  title="풍력">
											        <label for="carbon2" class="lab_check" title="풍력"><span class="icon ico_check"></span>풍력</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon3" value="HD" title="수소">
											        <label for="carbon3" class="lab_check" title="수소"><span class="icon ico_check"></span>수소</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon4" value="BM" title="바이오패스">
											        <label for="carbon4" class="lab_check" title="바이오패스"><span class="icon ico_check"></span>바이오패스</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon5" value="IE" title="산업효율">
											        <label for="carbon5" class="lab_check" title="산업효율"><span class="icon ico_check"></span>산업효율</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon6" value="TE" title="수송효율">
											        <label for="carbon6" class="lab_check" title="수송효율"><span class="icon ico_check"></span>수송효율</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon7" value="BE" title="건물효율">
											        <label for="carbon7" class="lab_check" title="건물효율"><span class="icon ico_check"></span>건물효율</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon8" value="DI" title="디지털화">
											        <label for="carbon8" class="lab_check" title="디지털화"><span class="icon ico_check"></span>디지털화</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon9" value="CC" title="CCUS">
											        <label for="carbon9" class="lab_check" title="CCUS"><span class="icon ico_check"></span>CCUS</label>
											    </div>
											    <div class="box_checkinp">
											        <input type="checkbox" class="inp_check" name="sector_opt"   id="carbon10" value="CI" title="융합혁신">
											        <label for="carbon10" class="lab_check" title="융합혁신"><span class="icon ico_check"></span>융합혁신</label>
											    </div>
											 </td>
										</tr>
										<tr>
											<th scope="col" colspan="2">바우처 과제명<span class="red">*</span></th>
											<td colspan="5">
												<input id="subject_title" name="subject_title" type="text" placeholder="바우처 과제를 입력하세요" style="width:100%" title="바우처과제명" maxlength="100" />
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="25">참<br>여<br>기<br>관<br></th>
											<th scope="col" rowspan="13">서비스<br>수요기업
											</th>
											<th scope="col" rowspan="5">기업명<br>(주력 품목은<br>제조업은
												대표<br>생산 품목<br>서비스업 대표<br>서비스 분야)
											</th>
											<td colspan="2"> 
												<input type="text" name="dc_biz_name" id="dc_biz_name" placeholder="기업명을 입력하세요" style="width:100%" title="수요기업명" value="${user.biz_name}" disabled="disabled"/>
											</td>
											<th scope="col">사업자 등록번호</th>
											<td class="tg-0pky">
												<input type="text" name="dc_biz_regno" id="dc_biz_regno" placeholder="사업자 등록번호를 입력하세요" style="width:100%" title="수요기업사업자등록번호" value="${user.biz_regno}" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col">주소</th>
											<td>
												<input type="text" name="dc_biz_address" id="dc_biz_address" placeholder="주소 를 입력하세요"  style="width:100%" title="수요기업주소" value="${user.address1}" disabled="disabled"/>
											</td>
											<th scope="col">홈페이지</th>
											<td class="tg-0pky">
												<input type="text"	name="dc_homepage" id="dc_homepage" placeholder="홈페이지 주소 를 입력하세요"  style="width:100%" title="수요기업홈페이지주소" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col">기업유형</th>
											<td colspan="3" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="dc_biz_size"   id="company1" value="MD0" title="수요기업 기업유형 - 중견기업">
													<label for="company1" class="lab_radio" title="중견기업"><span class="icon ico_radio"></span> 중견기업</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="dc_biz_size"   id="company2" value="MS0" title="수요기업 기업유형 - 중소기업">
													<label for="company2" class="lab_radio" title="중소기업"><span class="icon ico_radio"></span>중소기업</label>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="col">업종</th>
											<td>
												<input type="text" name="dc_biz_type" id="dc_biz_type" placeholder="업종을 입력하세요"  style="width:100%" title="수요기업 업종" disabled="disabled"/>
											</td>
											<th scope="col">주력 품목</th>
											<td>
												<input type="text" name="dc_biz_item" id="dc_biz_item" placeholder="주력품목 을  입력하세요"  style="width:100%" title="수요기업 주력품목" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col">대표자</th>
											<td>
												<input type="text"	name="dc_owner" id="dc_owner" placeholder="이름을 입력하세요"  style="width:100%" title="수요기업 대표자" value="${user.owner}" disabled="disabled"/>
											</td>
											<th scope="col">전화</th>
											<td>
												<input type="tel" name="dc_tel_no" id="dc_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" title="수요기업 전화" value="${user.tel_no}" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="4">총괄 책임자</th>
											<th scope="col">성명<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic1_name" id="dc_pic1_name" maxlength="50" placeholder="이름을 입력하세요" style="width:100%" title="수요기업 총괄책임자  이름" value="${user.user_name}"/>
											</td>
											<th scope="col">직급(직위)<span class="red">*</span></th>
											<td>
												<input type="text"	name="dc_pic1_rank" id="dc_pic1_rank" maxlength="50" placeholder="직급을 입력하세요" style="width:100%" title="수요기업 총괄책임자 직급" value="${user.user_rank}"/>
											</td>
										</tr>
										<tr>
											<th scope="col">소속부서<span class="red">*</span></th>
											<td>
												<input type="text"	name="dc_pic1_depart" id="dc_pic1_depart" maxlength="50" placeholder="소속부서를 입력하세요" style="width:100%" title="수요기업 총괄책임자 부서" value="${user.depart}"/>
											</td>
											<th scope="col">전공<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic1_major" id="dc_pic1_major" maxlength="50" placeholder="전공을 입력하세요" style="width:100%" title="수요기업 총괄책임자 전공"/>
											</td>
										</tr>
										<tr>
											<th scope="col">전화<span class="red">*</span></th>
											<td>
												<input type="text"	name="dc_pic1_tel_no" id="dc_pic1_tel_no" maxlength="20" placeholder="전화번호를 입력하세요" style="width:100%" title="수요기업 총괄책임자 전화번호" value="${user.user_tel_no}"/>
											</td>
											<th scope="col">E-mail<span class="red">*</span></th>
											<td>
												<input type="text"	name="dc_pic1_email" id="dc_pic1_email" maxlength="100" placeholder="E-mail 을 입력하세요" style="width:100%" title="수요기업 총괄책임자  E-mail" value="${user.user_email}"/>
											</td>
										</tr>
										<tr>
											<th scope="col">휴대전화<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic1_mobile_no" id="dc_pic1_mobile_no" maxlength="20" placeholder="휴대전화 번호를 입력하세요" style="width:100%" title="수요기업 총괄책임자 휴대전화" value="${user.user_mobile_no}"/>
											</td>
											<th scope="col">팩스번호</th>
											<td>
												<input type="text"	name="dc_pic1_fax_no" id="dc_pic1_fax_no" maxlength="20" placeholder="팩스번호를  입력하세요" style="width:100%" title="수요기업 총괄책임자 팩스번호" value="${user.user_fax_no}"/>
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="4">실무자</th>
											<th scope="col">성명<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_name" id="dc_pic2_name" maxlength="50" placeholder="이름을 입력하세요" maxlength="50" style="width:100%" title="수요기업 실무자 이름"/>
											</td>
											<th scope="col">직급(직위)<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_rank" id="dc_pic2_rank" maxlength="50" placeholder="직급을 입력하세요" maxlength="50" style="width:100%" title="수요기업 실무자 직급"/>
											</td>
										</tr>
										<tr>
											<th scope="col">소속부서<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_depart" id="dc_pic2_depart" maxlength="50" placeholder="소속부서를 입력하세요" maxlength="50" style="width:100%" title="수요기업 실무자 소속부서"/>
											</td>
											<th scope="col">전공<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_major" id="dc_pic2_major" maxlength="50" placeholder="전공을 입력하세요" maxlength="50" style="width:100%" title="수요기업 실무자 전공"/>
											</td>
										</tr>
										<tr>
											<th scope="col">전화<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_tel_no" id="dc_pic2_tel_no" maxlength="20" placeholder="전화번호를 입력하세요" maxlength="20" style="width:100%" title="수요기업 실무자 전화번호"/>
											</td>
											<th scope="col">E-mail<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_email" id="dc_pic2_email" 	maxlength="100" placeholder="E-mail 를 입력하세요" maxlength="100" style="width:100%" title="수요기업 실무자 E-mail"/>
											</td>
										</tr>
										<tr>
											<th scope="col">휴대전화<span class="red">*</span></th>
											<td>
												<input type="text" name="dc_pic2_mobile_no" id="dc_pic2_mobile_no" maxlength="20" placeholder="휴대전화를 입력하세요" maxlength="20" style="width:100%" title="수요기업 실무자 휴대전화"/>
											</td>
											<th scope="col">팩스번호</th>
											<td>
												<input type="text" name="dc_pic2_fax_no" id="dc_pic2_fax_no" maxlength="20" placeholder="팩스번호를 입력하세요" maxlength="20" style="width:100%" title="수요기업 실무자 팩스번호"/>
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="12">서비스<br>공급기업<br>(수행기업) <a id="search_sc" href="#layer2" class="btn-example btn_step" style="height:60px;" title="공급기관 검색">공급기관 검색 </a>    </th> 
											<th scope="col" rowspan="4">기업명</th>
											<td colspan="2">
												<input type="text" name="sc_biz_name" id="sc_biz_name" 	placeholder="기업명을 입력하세요" style="width:100%" title="공급기업  기업명" disabled="disabled"/>
											</td>
											<th scope="col">사업자 등록번호</th>
											<td>
												<input type="text" name="sc_biz_regno" id="sc_biz_regno" placeholder="사업자 등록번호를  입력하세요" style="width:100%" title="공급기업  사업자등록번호" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col">주소</th>
											<td>
												<input type="text" name="sc_biz_address" id="sc_biz_address" 	placeholder="주소를 입력하세요" style="width:100%" title="공급기업  주소" disabled="disabled"/>
											</td>
											<th scope="col">홈페이지</th>
											<td>
												<input type="text" name="sc_biz_homepage" id="sc_biz_homepage" placeholder="홈페이지 주소를 입력하세요" style="width:100%" title="공급기업  홈페이지" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col">기업유형</th>
											<td colspan="3" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sc_biz_size"   id="companyType1" value="MD0" title="연구개발업">
													<label for="companyType1" class="lab_radio" title="연구개발업"><span class="icon ico_radio"></span>연구개발업</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sc_biz_size"   id="companyType2" value="MS0" title="연구개발지원업">
													<label for="companyType2" class="lab_radio" title="연구개발지원업"><span class="icon ico_radio"></span>연구개발지원업</label>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="col">대표자</th>
											<td>
												<input type="text" name="sc_biz_owner" id="sc_biz_owner" placeholder="이름을 입력하세요" style="width:100%" title="공급기업  대표 이름" disabled="disabled"/>
											</td>
											<th scope="col">전화</th>
											<td>
												<input type="hidden" name="sc_member_seqno" id="sc_member_seqno"   title = "114" value=""/>
												<input type="text" name="sc_biz_tel_no" id="sc_biz_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" title="공급기업  대표 전화" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="4">수행 책임자</th>
											<th scope="col">성명<span class="red">*</span></th>
											<td>
												<input type="text"	name="sc_pic1_name" id="sc_pic1_name"  placeholder="이름을 입력하세요" maxlength="50"  style="width:100%" title="공급기업 수행책임자  이름"/>
											</td>
											<th scope="col">직급(직위)<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic1_rank" id="sc_pic1_rank" placeholder="직급을 입력하세요" maxlength="50" style="width:100%" title="공급기업 수행책임자  직급"/>
											</td>
										</tr>
										<tr>
											<th scope="col">소속부서<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic1_depart" id="sc_pic1_depart" placeholder="소속부서를 입력하세요" maxlength="50" style="width:100%" title="공급기업 수행책임자  소속부서"/>
											</td>
											<th scope="col">전공<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic1_major" id="sc_pic1_major" placeholder="전공을 입력하세요" maxlength="50" style="width:100%" title="공급기업 수행책임자  전공"/>
											</td>
										</tr>
										<tr>
											<th scope="col">전화<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic1_tel_no" id="sc_pic1_tel_no" placeholder="전화번호를 입력하세요" maxlength="20" style="width:100%" title="공급기업 수행책임자  전화번호"/>
											</td>
											<th scope="col">E-mail<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic1_email" id="sc_pic1_email" placeholder="Email 를 입력하세요" maxlength="100" style="width:100%" title="공급기업 수행책임자  E-mail"/>
											</td>
										</tr>
										<tr>
											<th scope="col">휴대전화<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic1_mobile_no" id="sc_pic1_mobile_no"	placeholder="휴대전화 번호를 입력하세요" maxlength="20" style="width:100%" title="공급기업 수행책임자  휴대전화"/>
											</td>
											<th scope="col">팩스번호</th>
											<td>
												<input type="text" name="sc_pic1_fax_no" id="sc_pic1_fax_no"
												placeholder="팩스번호를 입력하세요" style="width:100%" maxlength="20" title="공급기업 수행책임자  팩스번호"/></td>
										</tr>
										<tr>
											<th scope="col" rowspan="4">실무자</th>
											<th scope="col">성명<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_name" id="sc_pic2_name"
												placeholder="이름을 입력하세요" style="width:100%" title="공급기업 실무자   이름" maxlength="50"/></td>
											<th scope="col">직급(직위)<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_rank" id="sc_pic2_rank"
												placeholder="직급을 입력하세요" style="width:100%" title="공급기업 실무자   직급" maxlength="50"/></td>
										</tr>
										<tr>
											<th scope="col">소속부서<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_depart" id="sc_pic2_depart"
												placeholder="소속부서를 입력하세요" style="width:100%" title="공급기업 실무자   소속부서" maxlength="50"/></td>
											<th scope="col">전공<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_major" id="sc_pic2_major" placeholder="전공 입력하세요" style="width:100%" title="공급기업 실무자   전공" maxlength="50"/>
											</td>
										</tr>
										<tr>
											<th scope="col">전화<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_tel_no" id="sc_pic2_tel_no"
												placeholder="전화번호를 입력하세요" style="width:100%" title="공급기업 실무자   전화" maxlength="20"/></td>
											<th scope="col">E-mail<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_email" id="sc_pic2_email"
												placeholder="E-mail 를 입력하세요" style="width:100%" title="공급기업 실무자   E-mail" maxlength="100"/></td>
										</tr>
										<tr>
											<th scope="col">휴대전화<span class="red">*</span></th>
											<td>
												<input type="text" name="sc_pic2_mobile_no" id="sc_pic2_mobile_no"
												placeholder="휴대전화 번호를 입력하세요" style="width:100%" title="공급기업 실무자   휴대전화" maxlength="20"/></td>
											<th scope="col">팩스번호</th>
											<td>
												<input type="text" name="sc_pic2_fax_no" id="sc_pic2_fax_no"
												placeholder="팩스번호 를 입력하세요" style="width:100%" title="공급기업 실무자   팩스" maxlength="20"/></td>
										</tr>
										<tr>
											<th scope="col" colspan="2">수행기간<span class="red">*</span></th>
											<td colspan="5" class="ta_left">
												<input type="text" id="subject_sdate" name = "subject_sdate" style="text-align : center; width:30%" title="수행기간시작일"/>  ~ 
												<input type="text" id="subject_edate" name = "subject_edate"  style="text-align : center; width:30%" title="수행기간종료일" onchange="call();"/>
												&nbsp;&nbsp; (  <label for="subject_term" title="개월수"><input type="text" readonly="readonly" value= "0" id="subject_term" name="subject_term" class="form_month" title="수행기간 개월수"/></label>   개월 ) 
											</td>
										</tr>
										<tr>
											<th scope="col" colspan="2" rowspan="4">바우쳐(정부) 지원<br>신청
												금액<br>(선택 분야 금액<br>작성 및 분야별<br>합계 금액 작성)
											</th>
											<td rowspan="4">총계 : 
												<input type="number" style="width:100%"  id="voucher_total" name="voucher_total" readonly="readonly" title="총계"/>
											</td>
											<th scope="col">성능평가 인증<span class="red">*</span></th>
											<td>
												<input type="number" id="bs10" name="bs10" style="width:100%" value=0  onchange="voucherTotal();" disabled="disabled" title="성능평가 인증 비용"/>
											</td>
											<th scope="col">인허가 컨설팅<span class="red">*</span></th>
											<td>
												<input type="number" id="bs20" name="bs20" style="width:100%" value=0  onchange="voucherTotal();" disabled="disabled" title="인허가 컨설팅 비용"/>
											</td>
										</tr>
										<tr>
											<th scope="col">IP 관리 컨설팅<span class="red">*</span></th>
											<td>
												<input type="number" id="bs30" name="bs30" style="width:100%" value=0 onchange="voucherTotal();" disabled="disabled" title="IP 관리 컨설팅 비용"/>
											</td>
											<th scope="col">사업화 컨설팅A<span class="red">*</span></th>
											<td>
												<input type="number" id="bs40" name="bs40" style="width:100%" value=0  onchange="voucherTotal();" disabled="disabled" title="사업화 컨설팅A 비용"/>
											</td>
										</tr>
										<tr>
											<th scope="col">신기술(신제품)<br>개발 R&amp;D 지원<span class="red">*</span>
											</th>
											<td>
												<input type="number" id="ts10" name="ts10" style="width:100%" value=0  onchange="voucherTotal();" disabled="disabled" title="신기술(씬제품 개발 R&D지원) 비용"/>
											</td>
											<th scope="col">사업화 컨설팅B<span class="red">*</span></th>
											<td>
												<input type="number" id="bs50" name="bs50" style="width:100%" value=0  onchange="voucherTotal();" disabled="disabled" title="사업화 컨설팅B 비용"/>
											</td>
											
										</tr>
										<tr>
											<th scope="col">기존기술<br>(기존제품) 개선<br>R&amp;D 지원<span class="red">*</span>
											</th>
											<td>
												<input type="number" id="ts20" name="ts20" style="width:100%" value=0  onchange="voucherTotal();" disabled="disabled" title="기술기술(기존제품)개선 R&D 지원 비용"/>
											</td>
											<th scope="col">시작품 제작 지원<span class="red">*</span></th>
											<td>
												<input type="number" id="ts30" name="ts30" style="width:100%" value=0 onchange="voucherTotal();" disabled="disabled" title="시작품 제작 지원 비용"/>
											</td>
										</tr>
										<tr>
											<th scope="col" rowspan="2" colspan="2">
												사업비
											</th>
											<th scope="col" colspan="2">
												총사업비
											</th>
											<td colspan="3">
												<label for="total_cost"></label><input type="number" name= "total_cost" id="total_cost" title="총사업비"/>
											</td>
										</tr>
										<tr>
											<th scope="col" colspan="2">
												정부출연금<span class="red">*</span>
											</th>
											<td>
												<label for="gov_cost"><input type="number" name="gov_cost" id="gov_cost"  onchange="totalCost()" title="정부출연금 비용"/></label>
											</td>
											<th scope="col">
												수요기업 지부담금<span class="red">*</span>
											</th>
											<td>
												<label for="com_cost"><input type="number" name="com_cost" id="com_cost" onchange="totalCost()" title="수요기업 지부담금 비용" /></label>
											</td>
										</tr>
									</tbody>
									<tfoot></tfoot>
								</table>
							</form>
                            </div>
                        </div>
						<div class="area_cont area_cont2">
                            <div class="subject_corp">
                                <h4>제출서류</h4>
                            </div>
                            <div  id="uploadArea"></div>
                        </div>
                        <div class="wrap_btn _center">
							<a href="/subject/applyList.do" class="btn_list" title="목록으로이동">목록으로 이동</a> 
                           	<a href="javascript:void(0);" onclick="validataCheck('10','#btn_save');" class="btn_appl" id="btn_save" title="새창열기 작성내용 임시저장" target="_blank">작성내용 임시저장 </a>
							<a href="javascript:void(0);" class="btn_appl" onclick="validataCheck('20','#btn_submit');" id="btn_submit" title="새창열기 사업신청서 제출" target="_blank">사업신청서 제출</a>
                            
                        </div>
						<!-- //page_content e:  -->
					</div>
				</div>
			</div>
			<!-- //compaVcContent e:  -->

<div class="dim-layer idCls">
    <div class="dimBg"></div>
    <div id="layer2" class="pop-layer" style="height:500px">
        <div class="pop-container">
        <div class="pop-title"><h3>공급기관 찾기</h3><a href="javascript:void(0);" class="btn-layerClose" title="공급기관 찾기 팝업 닫기"><span class="icon ico_close">팝업닫기</span></a></div>
            <div class="pop-conts">
                <!--content //-->
               <p class="pop-info">검색할 공급기관에 사업자번호를 입력하세요.</p>
               <div class="form-inline pop-search-box"> <input type="text" id="searchApply" name="searchApply"  placeholder="사업자번호를 입력하세요" style="width:260px" title="사업자번호"/>
               <button type="button" onClick="doSearchApply()" class="btn_step" id="btn_search_apply" title="사업자번호 검색">검색</button></div>
              
               <div style="overflow-y:auto; height:300px">
               <div class="tbl_comm tbl_public" id="applyData"  style="margin-top:10px" >
               </div>
               <div class="tbl_public" >
					<div style="text-align:center;margin-top:20px;">
	                	<button type="button" class="btn_step" id="cancelAlert" name="btnCancel" title="공급기관찾기 팝업 닫기">닫기</button>
	               	</div>
               </div>
                <!--// content-->
            </div>
        </div>
    	</div>
	</div>
</div>
