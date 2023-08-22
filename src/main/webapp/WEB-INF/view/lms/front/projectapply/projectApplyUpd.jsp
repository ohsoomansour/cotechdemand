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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1"></link>


<script>
var selectData ;
window.onload = () =>{
	console.log("어케나올까요","${paraMap.subject.subject_name}")
	 var options = {
		    	fmstSeq: ${paraMap.fmst_seq},
		    	//fmstSeq: 11,
		        types: [
		            {text: '사업신청서', value: 'BA', isRequired: false,},
		            {text: '매칭신청서', value: 'MA', isRequired: false,},
		            {text: '기업확인서', value: 'CC', isRequired: false,},
		            {text: '기타', value: 'ETC', isRequired: false,},
		        ],
		        callback: function(data){
		        	if(data == 0 || data == undefined){
		        		alert_popup("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
				    	return false;
				    	}
			    	doData(status,data);
				},
		    };
		    window.uploadSrc.create($('#uploadArea'), options);
		    var sector_lev1 ='${paraMap.subject.sector_lev1}' ;
		    $('#area'+sector_lev1).prop("checked",true);
		    if(sector_lev1 == 'BS'){
		    	$('#support${paraMap.subject.sector_lev2}').prop("checked",true);
			    }
		    else if(sector_lev1 == 'TS'){
		    	$('#technology${paraMap.subject.sector_lev2}').prop("checked",true);
			    }
		    $('#opt_${paraMap.subject.sector_opt}').prop("checked",true);
		    $('#dc_company_${paraMap.dcdata.biz_size}').prop("checked",true);
		    $('#sc_company_${paraMap.scdata.biz_size}').prop("checked",true);
		   

		    
}
//유효성체크
function validataCheck(stat){
	console.log("validateCheck")
	//null체크 후 
	
	var check = confirm("작성하신 사업계획서를 저장하시겠습니까? ")
		if (check == true) {
			uploadFile(stat)
		}
	
}
function uploadFile(stat){
	status = stat;
	var empty = document.getElementsByClassName('file-empty')[0];
	//console.log(empty);
	if(empty==undefined){
		//파일전송후 공고등록
		uploadSrc.startUpload();
	}
	else{
		//alert("")
		//공고등록
		doData(status);
	}
}

	function doData(stat,fmstSeqno) {
		console.log("fmstseqno들어오나요?",fmstSeqno)
		var url = "/subject/applySubmit.do";
		var form = $('#frm')[0];
		var data = new FormData(form);
		if(fmstSeqno != undefined){
			data.append("fmst_seqno",fmstSeqno);
			}
		console.log("fmst_seqno들어가나요",data);
		var project_seqno = $('#project_seqno').val();
		//console.log(project_seqno,"project_seqno");
		var subject_seqno = $('#subject_seqno').val();
		//console.log(subject_seqno,"subject_seqno");
		if(stat == "save"){
			//$('#status').val("save");
			data.append("status","save");
			}
		else if(stat == "submit"){
			//$('#status').val("submit");
			data.append("status","submit");
			}
		else if(stat == "update"){
			//$('#status').val("update");
			data.append("status","update");
			}
		$.ajax({
		       url : url,
		       type: "post",
		       processData: false,
		       contentType: false,
		       data: data,
		       dataType: "json",
		       success : function(res){
		    	alert_popup('신청 되었습니다',res);
		       	//window.location.href = "/admin/projectapply/list.do?offset=1&limit=10";
		       	window.location.href="/projectapply/applyFin.do?status=save"
		       	console.log("결과",res);   
		       },
		       error : function(){
		    	alert_popup('게시판 등록에 실패했습니다.');    
		       },
		       complete : function(){
			       
		       	//parent.fncList();
		       	//parent.$("#dialog").dialog("close");
		       }
		}); 
	}
	function doSubmit() {
		var check = confirm("작성하신 사업계획서를 제출하시겠습니까? ")
		if (check == true) {
			window.location.href="/projectapply/applyFin.do?status=submit"
			/* $.ajax({
		        url : "/announcement/applyFin.do",
		        type : "POST",
		        dataType : 'json',
		        data : 
		        { 
		        	
		        },
		        success : function(result){ 
		        	alert('이동성공');
		        },
		        error : function(e) {
		        	alert(e);
		        }
			});  */
			//alert("제출되었습니다.")
		}
	}

	$(document).ready(function () {
        $.datepicker.setDefaults($.datepicker.regional['ko']); 
        $( "#startDate" ).datepicker({
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
                 $("#endDate").datepicker( "option", "minDate", selectedDate );
             }    

        });
        $( "#endDate" ).datepicker({
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
                 $("#startDate").datepicker( "option", "maxDate", selectedDate );
                 call();
             }    

        }); 

        $('.btn-example').click(function(){
	        var $href = $(this).attr('href');
	        layer_popup($href);
	    });

      //radio버튼 제어 
        $("input[name='sector_lev1']").click(function () {
			console.log("짠",$("input[name='sector_lev1']:checked").val())
			var value = $("input[name='sector_lev1']:checked").val();
			if(value=="TS"){
				$("input[id='technology1']").prop("checked",true);
				$("#technology1").removeAttr('disabled');
				$("#technology2").removeAttr('disabled');
				$("#technology3").removeAttr('disabled');
				$("#support1").attr('disabled', 'true');
				$("#support2").attr('disabled', 'true');
				$("#support3").attr('disabled', 'true');
				$("#support4").attr('disabled', 'true');
				}
			else if(value=="BS"){
				$("input[id='support1']").prop("checked",true);
				$("#technology1").attr('disabled', 'true');
				$("#technology2").attr('disabled', 'true');
				$("#technology3").attr('disabled', 'true');
				$("#support1").removeAttr('disabled');
				$("#support2").removeAttr('disabled');
				$("#support3").removeAttr('disabled');
				$("#support4").removeAttr('disabled');
				}
        });
	    
	    function layer_popup(el){

	        var $el = $(el);    //레이어의 id를 $el 변수에 저장
	        var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

	        isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();

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

	        $el.find('.btn-layerClose').click(function(){
	            isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
	            return false;
	        });

	        $('.layer .dimBg').click(function(){
	            $('.dim-layer').fadeOut();
	            return false;
	        });

	    }  

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
	    var sdd = document.getElementById("startDate").value;
	    var edd = document.getElementById("endDate").value;
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
	    document.getElementById('month').value = parseInt(dif/cMonth)
	    //document.getElementById('days').value = parseInt(dif/cDay)
	 }
	}

	//체크박스 하나만 선택되게 하기
	function checkOnlyOne(element,name) {
		  console.log(element,name,"뭐드러와요")
		  var checkboxes 
		      = document.getElementsByName(name);
		  
		  checkboxes.forEach((cb) => {
		    cb.checked = false;
		    //console.log(cb,"되는건가");
		  })
		  //console.log(element,"되는건2가");
		  element.checked = true;
		}

	//임시데이터셋팅
	function setData(){
		   $('input[type="text"]').each(function(){
		      $(this).val($(this).attr('hiddenVal'));
		   });

		   $('input[type="checkbox"]').each(function(){
		      $(this).find('input').eq(0).attr("checked","checked") ;
		   });
		   $('textarea').each(function(){
			      $(this).val($(this).attr('hiddenVal'));
			   });
		   call();
		}

	
	//공급기관 사업자번호로 검색하기
	function doSearchApply(){
		var applyNo = document.getElementById('searchApply').value;
		var ahtml = "<br/>";
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
				        ahtml+= "<td><button type='button' class='btn_step' onClick='clickData("+i+")' >선택</button></td>";
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
	        	alert_popup('검색 실패하였습니다.');    
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
		var ts10 = $('#ts10').val()*1;
		var ts20 = $('#ts20').val()*1;
		var ts30 = $('#ts30').val()*1;
		var sum = bs10 + bs20 + bs30 + bs40 + ts10 + ts20 + ts30 ;
		$('#voucher_total').val(sum); 
	}
</script>

<!-- compaVcContent s:  -->
			<div id="compaVcContent" class="cont_cv">
				<div id="mArticle" class="assig_app">
					<h2 class="screen_out">본문영역</h2>
					<div class="wrap_cont">
                        <!-- page_title s:  -->
						<div class="area_tit">
							<h3 class="tit_corp">
								<c:if test="${ !empty user}" >
									사업 신청서 작성
								</c:if>
								<c:if test="${ empty user }" >
									사업 신청서 수정
								</c:if>
							</h3>
						</div>
						<!-- //page_title e:  -->
						<!-- page_content s:  -->
						<div class="area_cont">
                            <div class="w_top">
								<h4 class="subject_corp">바우처사업관리시스템 사업 신청서</h4>
                            	<p class="es">* 표시는 필수 입력 사항입니다.</span>
                            </div>
							<div class="tbl_view tbl_public  tbl_public2">
							<form name="frm" id="frm" action = "#" method = "post" >
								<input type="hidden" name="project_seqno" id="project_seqno" value="${paraMap.project_seqno} " />
								<input type="hidden" name="subject_seqno" id="subject_seqno" value="${paraMap.subject_seqno} " />
								<input type="hidden" name="status_apply" id="status_apply" value ="${paraMap.status_apply}" />
								<table class="tbl">
									<caption class="caption_hide">사업신청 사업신청서</caption>
									<colgroup>
                                        <col style="width:80px">
                                        <col style="width:120px">
                                        <col style="width:120px">
                                        <col style="width:120px">
                                        <col>
                                        <col style="width:120px">
                                        <col>
                                    </colgroup>
									<tbody>
										<tr>
											<th colspan="2">협약 번호</th>
											<td colspan="5">
											<c:if test="${ !empty user }" >
												<input type="text" placeholder="협약번호를 입력하세요" style="width:100%" hiddenVal="test-00-00" value="${paraMap.project_title }"/>
											</c:if>
											<c:if test="${ empty user }" >
												<input type="text" placeholder="협약번호를 입력하세요" style="width:100%" hiddenVal="test-00-00" value="${paraMap.project_title }" readonly="readonly"/>
											</c:if>
												
											</td>
										</tr>
										<tr>
											<th colspan="2">사업명</th>
											<td colspan="5">
											<c:if test="${ !empty user }" >
												<input type="text" name="project_title" id="project_title" placeholder="사업명을 입력하세요" style="width:100%" hiddenVal="사업명" value="${paraMap.project_title }"/>
											</c:if>
											<c:if test="${ empty user }" >
												<input type="text" name="project_title" id="project_title" placeholder="사업명을 입력하세요" style="width:100%" hiddenVal="사업명" value="${paraMap.project_title }" readonly="readonly"/>
											</c:if>
												
											</td>
										</tr>
										<tr>
											<th rowspan="4">분야</th>
											<th>지원분야</th>
											<td colspan="5" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev1"   id="areaBS" value="BS" />
													<label for="areaBS" class="lab_radio"><span class="icon ico_radio"></span>사업화지원</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev1"   id="areaTS" value="TS" />
													<label for="areaTS" class="lab_radio"><span class="icon ico_radio"></span>기술개발지원</label>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="2">상세서비스</th>
											<th>사업화지원</th>
											<td colspan="4" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev2"   id="support10" value="10" >
													<label for="support1" class="lab_radio"><span class="icon ico_radio"></span>성능평가 인증</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio"  name = "sector_lev2" id="support20" value="20" >
													<label for="support2" class="lab_radio"><span class="icon ico_radio"></span>인허가 컨설팅</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev2"   id="support30" value="30" >
													<label for="support3" class="lab_radio"><span class="icon ico_radio"></span>IP 관리 컨설팅</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name = "sector_lev2" id="support40" value="40" >
													<label for="support4" class="lab_radio"><span class="icon ico_radio"></span>사업화 컨설팅</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>기술개발지원</th>
											<td colspan="4" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev2"   id="technology10"  value="10" >
													<label for="technology1" class="lab_radio"><span class="icon ico_radio"></span>신기술(신제품) 개발 R&amp;D 지원</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev2"   id="technology20" value="20" >
													<label for="technology2" class="lab_radio"><span class="icon ico_radio"></span>기존기술(기존제품) 개선 R&amp;D 지원</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_lev2"   id="technology30" value="30" >
													<label for="technology3" class="lab_radio"><span class="icon ico_radio"></span>시제품 제작 지원</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>탄소중립<br>해당여부</th>
											<td colspan="5" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_SL"  value="SL" >
													<label for="opt_SL" class="lab_radio"><span class="icon ico_radio"></span>태양광</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_WP"  value="WP" >
													<label for="opt_WP" class="lab_radio"><span class="icon ico_radio"></span>풍력</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_HD" value="HD" >
													<label for="opt_HD" class="lab_radio"><span class="icon ico_radio"></span>수소</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_BM" value="BM" >
													<label for="opt_BM" class="lab_radio"><span class="icon ico_radio"></span>바이오패스</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_IE" value="IE" >
													<label for="opt_IE" class="lab_radio"><span class="icon ico_radio"></span>산업효율</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_TE" value="TE" >
													<label for="opt_TE" class="lab_radio"><span class="icon ico_radio"></span>수송효율</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_BE" value="BE" >
													<label for="opt_BE" class="lab_radio"><span class="icon ico_radio"></span>건물효율</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_DI" value="DI" >
													<label for="opt_DI" class="lab_radio"><span class="icon ico_radio"></span>디지털화</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_CC" value="CC" >
													<label for="opt_CC" class="lab_radio"><span class="icon ico_radio"></span>CCUS</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sector_opt"   id="opt_CI" value="CI" >
													<label for="opt_CI" class="lab_radio"><span class="icon ico_radio"></span>융합혁신</label>
												</div>
											 </td>
										</tr>
										<tr>
											<th colspan="2">바우처 과제명</th>
											<td colspan="5">
												<input id="subject_name" name="subject_name" type="text" placeholder="바우처 과제를 입력하세요" style="width:100%" hiddenVal="바우처과제" value="${paraMap.subject.subject_title }"/>
											</td>
										</tr>
										<tr>
											<th rowspan="25">참<br>여<br>기<br>관<br></th>
											<th rowspan="13">서비스<br>수요기업
											</th>
											<th rowspan="5">기업명<br>(주력 품목은<br>제조업은
												대표<br>생산 품목<br>서비스업 대표<br>서비스 분야)
											</th>
											<td colspan="2"> 
												<input type="text" name="dc_biz_name" id="dc_biz_name" placeholder="기업명을 입력하세요" style="width:100%" hiddenVal="수요기업명" value="${paraMap.dcdata.biz_name}"/>
											</td>
											<th>사업자 등록번호</th>
											<td class="tg-0pky">
												<input type="text" name="dc_biz_regno" id="dc_biz_regno" placeholder="사업자 등록번호를 입력하세요" style="width:100%" hiddenVal="수요기업사업자등록번호" value="${paraMap.dcdata.biz_regno}"/>
											</td>
										</tr>
										<tr>
											<th>주소</th>
											<td>
												<input type="text" name="dc_biz_address" id="dc_biz_address" placeholder="주소 를 입력하세요"  style="width:100%" hiddenVal="수요기업주소" value="${paraMap.dcdata.address1}"/>
											</td>
											<th>홈페이지</th>
											<td class="tg-0pky">
												<input type="text"	name="dc_homepage" id="dc_homepage" placeholder="홈페이지 주소 를 입력하세요"  style="width:100%" hiddenVal="수요기업홈페이지주소" value="${paraMap.dcdata.homepage}"/>
											</td>
										</tr>
										<tr>
											<th>기업유형</th>
											<td colspan="3" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="dc_biz_size"   id="dc_company_MD0" value="MD0" >
													<label for="company_MD0" class="lab_radio"><span class="icon ico_radio"></span> 중견기업</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="dc_biz_size"   id="dc_company_MS0" value="MS0" >
													<label for="company_MS0" class="lab_radio"><span class="icon ico_radio"></span>중소기업</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>업종</th>
											<td>
												<input type="text" name="dc_biz_type" id="dc_biz_type" placeholder="업종을 입력하세요"  style="width:100%" hiddenVal="수요기업 업종" value="${paraMap.dcdata.biz_type}"/>
											</td>
											<th>주력 품목</th>
											<td>
												<input type="text" name="dc_biz_item" id="dc_biz_item" placeholder="주력품목 을  입력하세요"  style="width:100%" hiddenVal="수요기업 주력품목" value="${paraMap.dcdata.biz_item}"/>
											</td>
										</tr>
										<tr>
											<th>대표자</th>
											<td>
												<input type="text"	name="dc_owner" id="dc_owner" placeholder="이름을 입력하세요"  style="width:100%" hiddenVal="수요기업 대표자" value="${paraMap.dcdata.owner}"/>
											</td>
											<th>전화</th>
											<td>
												<input type="tel" name="dc_tel_no" id="dc_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" hiddenVal="수요기업 전화" value="${paraMap.dcdata.tel_no}"/>
											</td>
										</tr>
										<tr>
											<th rowspan="4">총괄 책임자</th>
											<th>성명</th>
											<td>
												<input type="text" name="dc_pic1_name" id="dc_pic1_name" placeholder="이름을 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자  이름" value="${paraMap.dcdata.pic1_name}"/>
											</td>
											<th>직급(직위)</th>
											<td>
												<input type="text"	name="dc_pic1_rank" id="dc_pic1_rank" placeholder="직급을 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자 직급" value="${paraMap.dcdata.pic1_rank}"/>
											</td>
										</tr>
										<tr>
											<th>소속부서</th>
											<td>
												<input type="text"	name="dc_pic1_depart" id="dc_pic1_depart" placeholder="소속부서를 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자 부서" value="${paraMap.dcdata.pic1_depart}"/>
											</td>
											<th>전공</th>
											<td>
												<input type="text" name="dc_pic1_major" id="dc_pic1_major" placeholder="전공을 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자 전공" value="${paraMap.dcdata.pic1_major}"/>
											</td>
										</tr>
										<tr>
											<th>전화</th>
											<td>
												<input type="text"	name="dc_pic1_tel_no" id="dc_pic1_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자 전화번호" value="${paraMap.dcdata.pic1_tel_no}"/>
											</td>
											<th>E-mail</th>
											<td>
												<input type="text"	name="dc_pic1_email" id="dc_pic1_email" placeholder="E-mail 을 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자  E-mail" value="${paraMap.dcdata.pic1_email}"/>
											</td>
										</tr>
										<tr>
											<th>휴대전화</th>
											<td>
												<input type="text" name="dc_pic1_mobile_no" id="dc_pic1_mobile_no" placeholder="휴대전화 번호를 입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자 휴대전화" value="${paraMap.dcdata.pic1_mobile_no}"/>
											</td>
											<th>팩스번호</th>
											<td>
												<input type="text"	name="dc_pic1_fax_no" id="dc_pic1_fax_no" placeholder="팩스번호를  입력하세요" style="width:100%" hiddenVal="수요기업 총괄책임자 팩스번호" value="${paraMap.dcdata.pic1_fax_no}"/>
											</td>
										</tr>
										<tr>
											<th rowspan="4">실무자</th>
											<th>성명</th>
											<td>
												<input type="text" name="dc_pic2_name" id="dc_pic2_name" placeholder="이름을 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 이름" value="${paraMap.dcdata.pic2_name}"/>
											</td>
											<th>직급(직위)</th>
											<td>
												<input type="text" name="dc_pic2_rank" id="dc_pic2_rank"  placeholder="직급을 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 직급" value="${paraMap.dcdata.pic2_rank}"/>
											</td>
										</tr>
										<tr>
											<th>소속부서</th>
											<td>
												<input type="text" name="dc_pic2_depart" id="dc_pic2_depart" placeholder="소속부서를 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 소속부서" value="${paraMap.dcdata.pic2_depart}"/>
											</td>
											<th>전공</th>
											<td>
												<input type="text" name="dc_pic2_major" id="dc_pic2_major" placeholder="전공을 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 전공" value="${paraMap.dcdata.pic2_major}"/>
											</td>
										</tr>
										<tr>
											<th>전화</th>
											<td>
												<input type="text" name="dc_pic2_tel_no" id="dc_pic2_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 전화번호" value="${paraMap.dcdata.pic2_tel_no}"/>
											</td>
											<th>E-mail</th>
											<td>
												<input type="text" name="dc_pic2_email" id="dc_pic2_email" 	placeholder="E-mail 를 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 E-mail" value="${paraMap.dcdata.pic2_email}"/>
											</td>
										</tr>
										<tr>
											<th>휴대전화</th>
											<td>
												<input type="text" name="dc_pic2_mobile_no" id="dc_pic2_mobile_no" placeholder="휴대전화를 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 휴대전화" value="${paraMap.dcdata.pic2_mobile_no}"/>
											</td>
											<th>팩스번호</th>
											<td>
												<input type="text" name="dc_pic2_fax_no" id="de_pic2_fax_no" placeholder="팩스번호를 입력하세요" style="width:100%" hiddenVal="수요기업 실무자 팩스번호" value="${paraMap.dcdata.pic2_fax_no}"/>
											</td>
										</tr>
										<tr>
											<th rowspan="12">서비스<br>공급기업<br>(수행기업) <a href="#layer2" class="btn-example btn_step">공급기관 찾기 </a>    </th> 
											<th rowspan="4">기업명</th>
											<td colspan="2">
												<input type="text" name="sc_biz_name" id="sc_biz_name" 	placeholder="기업명을 입력하세요" style="width:100%" hiddenVal="공급기업  기업명" value="${paraMap.scdata.biz_name}"/>
											</td>
											<th>사업자 등록번호</th>
											<td>
												<input type="text" name="sc_biz_regno" id="sc_biz_regno" placeholder="사업자 등록번호를  입력하세요" style="width:100%" hiddenVal="공급기업  사업자등록번호" value="${paraMap.scdata.biz_regno}"/>
											</td>
										</tr>
										<tr>
											<th>주소</th>
											<td>
												<input type="text" name="sc_biz_address" id="sc_biz_address" 	placeholder="주소를 입력하세요" style="width:100%" hiddenVal="공급기업  주소" value="${paraMap.scdata.address1}"/>
											</td>
											<th>홈페이지</th>
											<td>
												<input type="text" name="sc_biz_homepage" id="sc_biz_homepage" placeholder="홈페이지 주소를 입력하세요" style="width:100%" hiddenVal="공급기업  홈페이지" value="${paraMap.scdata.homepage}"/>
											</td>
										</tr>
										<tr>
											<th>기업유형</th>
											<td colspan="3" class="ta_left">
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sc_biz_size"   id="sc_company_MD0" value="MD0" >
													<label for="sc_company_MD0" class="lab_radio"><span class="icon ico_radio"></span>연구개발업</label>
												</div>
												<div class="box_radioinp">
													<input type="radio" class="inp_radio" name="sc_biz_size"   id="sc_company_MS0" value="MS0" >
													<label for="sc_company_MS0" class="lab_radio"><span class="icon ico_radio"></span>연구개발지원업</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>대표자</th>
											<td>
												<input type="text" name="sc_biz_owner" id="sc_biz_owner" placeholder="이름을 입력하세요" style="width:100%" hiddenVal="공급기업  대표 이름" value="${paraMap.scdata.owner}"/>
											</td>
											<th>전화</th>
											<td>
												<input type="hidden" name="sc_member_seqno" id="sc_member_seqno"   hiddenVal = "114" value=""/>
												<input type="text" name="sc_biz_tel_no" id="sc_biz_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" hiddenVal="공급기업  대표 전화" value="${paraMap.scdata.tel_no}"/>
											</td>
										</tr>
										<tr>
											<th rowspan="4">수행 책임자</th>
											<th>성명</th>
											<td>
												<input type="text"	name="sc_pic1_name" id="sc_pic1_name"  placeholder="이름을 입력하세요"  style="width:100%" hiddenVal="수행책임자  이름" value="${paraMap.scdata.pic1_name}"/>
											</td>
											<th>직급(직위)</th>
											<td>
												<input type="text" name="sc_pic1_rank" id="sc_pic1_rank" placeholder="직급을 입력하세요" style="width:100%" hiddenVal="수행책임자  직급" value="${paraMap.scdata.pic1_rank}"/>
											</td>
										</tr>
										<tr>
											<th>소속부서</th>
											<td>
												<input type="text" name="sc_pic1_depart" id="sc_pic1_depart" placeholder="소속부서를 입력하세요" style="width:100%" hiddenVal="수행책임자  소속부서" value="${paraMap.scdata.pic1_depart}"/>
											</td>
											<th>전공</th>
											<td>
												<input type="text" name="sc_pic1_major" id="sc_pic1_major" placeholder="전공을 입력하세요" style="width:100%" hiddenVal="수행책임자  전공" value="${paraMap.scdata.pic1_major}"/>
											</td>
										</tr>
										<tr>
											<th>전화</th>
											<td>
												<input type="text" name="sc_pic1_tel_no" id="sc_pic1_tel_no" placeholder="전화번호를 입력하세요" style="width:100%" hiddenVal="수행책임자  전화번호" value="${paraMap.scdata.pic1_tel_no}"/>
											</td>
											<th>E-mail</th>
											<td>
												<input type="text" name="sc_pic1_email" id="sc_pic1_email" placeholder="Email 를 입력하세요" style="width:100%" hiddenVal="수행책임자  E-mail" value="${paraMap.scdata.pic1_email}"/>
											</td>
										</tr>
										<tr>
											<th>휴대전화</th>
											<td>
												<input type="text" name="sc_pic1_mobile_no" id="sc_pic1_mobile_no"	placeholder="휴대전화 번호를 입력하세요" style="width:100%" hiddenVal="수행책임자  휴대전화" value="${paraMap.scdata.pic1_mobile_no}"/>
											</td>
											<th>팩스번호</th>
											<td>
												<input type="text" name="sc_pic1_fax_no" id="sc_pic1_fax_no"
												placeholder="팩스번호를 입력하세요" style="width:100%" hiddenVal="수행책임자  팩스번호" value="${paraMap.scdata.pic1_fax_no}"/></td>
										</tr>
										<tr>
											<th rowspan="4">실무자</th>
											<th>성명</th>
											<td>
												<input type="text" name="sc_pic2_name" id="sc_pic2_name"
												placeholder="이름을 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   이름" value="${paraMap.scdata.pic2_name}"/></td>
											<th>직급(직위)</th>
											<td>
												<input type="text" name="sc_pic2_rank" id="sc_pic2_rank"
												placeholder="직급을 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   직급" value="${paraMap.scdata.pic2_rank}"/></td>
										</tr>
										<tr>
											<th>소속부서</th>
											<td>
												<input type="text" name="sc_pic2_depart" id="sc_pic2_depart"
												placeholder="소속부서를 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   소속부서" value="${paraMap.scdata.pic2_depart}"/></td>
											<th>전공</th>
											<td>
												<input type="text" name="sc_pic2_major" id="sc_pic2_major" placeholder="전공 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   전공" value="${paraMap.scdata.pic2_major}"/>
											</td>
										</tr>
										<tr>
											<th>전화</th>
											<td>
												<input type="text" name="sc_pic2_tel_no" id="sc_pic2_tel_no"
												placeholder="전화번호를 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   전화" value="${paraMap.scdata.pic2_tel_no}"/></td>
											<th>E-mail</th>
											<td>
												<input type="text" name="sc_pic2_email" id="sc_pic2_email"
												placeholder="E-mail 를 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   E-mail" value="${paraMap.scdata.pic2_email}"/></td>
										</tr>
										<tr>
											<th>휴대전화</th>
											<td>
												<input type="text" name="sc_pic2_mobile_no" id="sc_pic2_mobile_no"
												placeholder="휴대전화 번호를 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   휴대전화" value="${paraMap.scdata.pic2_mobile_no}"/></td>
											<th>팩스번호</th>
											<td>
												<input type="text" name="sc_pic2_fax_no" id="sc_pic2_fax_no"
												placeholder="팩스번호 를 입력하세요" style="width:100%" hiddenVal="공급기업 실무자   팩스" value="${paraMap.scdata.pic2_fax_no}"/></td>
										</tr>
										<tr>
											<th colspan="2">수행기간</th>
											<td colspan="5" class="ta_left">
												<input type="text" id="subject_sdate" name = "subject_sdate" style="text-align : center; width:30%" hiddenVal="2021-04-13" value="${paraMap.subject.subject_sdate }"/>  ~ 
												<input type="text" id="subject_edate" name = "subject_edate"  style="text-align : center; width:30%" hiddenVal="2021-08-24"value="${paraMap.subject.subject_edate }"/>
												&nbsp;&nbsp; (  <input type="text" readonly="readonly" id="subject_term" name="subject_term" class="form_month" value="${paraMap.subject.subject_term }"/>   개월 ) 
											</td>
										</tr>
										<c:if test = "${empty paraMap.cost }" >
										<tr>
											<th colspan="2" rowspan="4">바우쳐(정부) 지원<br>신청
												금액<br>(선택 분야 금액<br>작성 및 분야별<br>합계 금액 작성)
											</th>
											<td rowspan="4">총계 : 
												<input type="number" style="width:100%" hiddenVal=9999999 id="voucher_total" name="voucher_total" readonly="readonly"/>
											</td>
											<th>성능평가 인증</th>
											<td>
												<input type="number" id="bs10" name="bs10"style="width:100%" hiddenVal=" 성능평가인증" onchange="voucherTotal();"/>
											</td>
											<th>인허가 컨설팅</th>
											<td>
												<input type="number" id="bs20" name="bs20" style="width:100%" hiddenVal=" 인허가컨설팅" onchange="voucherTotal();"/>
											</td>
										</tr>
										<tr>
											<th>IP 관리 컨설팅</th>
											<td>
												<input type="number" id="bs30" name="bs30" style="width:100%" hiddenVal=" IP 관리 컨설팅" onchange="voucherTotal();"/>
											</td>
											<th>사업화 컨설팅</th>
											<td>
												<input type="number" id="bs40" name="bs40" style="width:100%" hiddenVal=" 사업화 컨설팅" onchange="voucherTotal();"/>
											</td>
										</tr>
										<tr>
											<th>신기술(신제품)<br>개발 R&amp;D 지원
											</th>
											<td>
												<input type="number" id="ts10" name="ts10" style="width:100%"hiddenVal=" 신기술지원" onchange="voucherTotal();"/>
											</td>
											<th>기존기술<br>(기존제품) 개선<br>R&amp;D 지원
											</th>
											<td>
												<input type="number" id="ts20" name="ts20" style="width:100%" hiddenVal=" 기존기술 개선" onchange="voucherTotal();"/>
											</td>
										</tr>
										<tr>
											<th colspan="2">시작품 제작 지원</th>
											<td colspan="2">
												<input type="number" id="ts30" name="ts30" style="width:100%" hiddenVal=" 시작품 제작 지원" onchange="voucherTotal();"/>
											</td>
										</tr>
										<tr>
											<th rowspan="2" colspan="2">
												사업비
											</th>
											<th colspan="2">
												총사업비
											</th>
											<td colspan="3">
												<input type="number" name= "total_cost" id="total_cost" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th colspan="2">
												정부출연금
											</th>
											<td>
												<input type="number" name="gov_cost" id="gov_cost"  onchange="totalCost()"/>
											</td>
											<th>
												수요기업 지부담금
											</th>
											<td>
												<input type="number" name="com_cost" id="com_cost" onchange="totalCost()"  />
											</td>
										</tr>
										</c:if>
										
										<c:if test = "${!empty paraMap.cost }" >
										<tr>
											<th colspan="2" rowspan="4">바우쳐(정부) 지원<br>신청
												금액<br>(선택 분야 금액<br>작성 및 분야별<br>합계 금액 작성)
											</th>
											<td rowspan="4">총계 : 
												<input type="number" style="width:100%" hiddenVal=9999999 id="voucher_total" name="voucher_total" readonly="readonly" value = '${paraMap.subject.voucher_total }'/>
											</td>
											<th>성능평가 인증</th>
											<td>
												<input type="number" id="bs10" name="bs10"style="width:100%" hiddenVal=" 성능평가인증" onchange="voucherTotal();" value= '${paraMap.cost[0].cost }'/>
											</td>
											<th>인허가 컨설팅</th>
											<td>
												<input type="number" id="bs20" name="bs20" style="width:100%" hiddenVal=" 인허가컨설팅" onchange="voucherTotal();" value= '${paraMap.cost[1].cost }'/>
											</td>
										</tr>
										<tr>
											<th>IP 관리 컨설팅</th>
											<td>
												<input type="number" id="bs30" name="bs30" style="width:100%" hiddenVal=" IP 관리 컨설팅" onchange="voucherTotal();" value= '${paraMap.cost[2].cost }'/>
											</td>
											<th>사업화 컨설팅</th>
											<td>
												<input type="number" id="bs40" name="bs40" style="width:100%" hiddenVal=" 사업화 컨설팅" onchange="voucherTotal();" value= '${paraMap.cost[3].cost }'/>
											</td>
										</tr>
										<tr>
											<th>신기술(신제품)<br>개발 R&amp;D 지원
											</th>
											<td>
												<input type="number" id="ts10" name="ts10" style="width:100%"hiddenVal=" 신기술지원" onchange="voucherTotal();" value= '${paraMap.cost[4].cost }'/>
											</td>
											<th>기존기술<br>(기존제품) 개선<br>R&amp;D 지원
											</th>
											<td>
												<input type="number" id="ts20" name="ts20" style="width:100%" hiddenVal=" 기존기술 개선" onchange="voucherTotal();" value= '${paraMap.cost[5].cost }'/>
											</td>
										</tr>
										<tr>
											<th colspan="2">시작품 제작 지원</th>
											<td colspan="2">
												<input type="number" id="ts30" name="ts30" style="width:100%" hiddenVal=" 시작품 제작 지원" onchange="voucherTotal();" value= '${paraMap.cost[6].cost }'/>
											</td>
										</tr>
										<tr>
											<th rowspan="2" colspan="2">
												사업비
											</th>
											<th colspan="2">
												총사업비
											</th>
											<td colspan="3">
												<input type="number" name= "total_cost" id="total_cost" readonly="readonly" value = "${paraMap.subject.total_cost}"/>
											</td>
										</tr>
										<tr>
											<th colspan="2">
												정부출연금
											</th>
											<td>
												<input type="number" name="gov_cost" id="gov_cost"  onchange="totalCost()" value="${paraMap.subject.gov_cost}"/>
											</td>
											<th>
												수요기업 지부담금
											</th>
											<td>
												<input type="number" name="com_cost" id="com_cost" onchange="totalCost()" value="${paraMap.subject.com_cost}" />
											</td>
										</tr>
										</c:if>
									</tbody>
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
                            <a href="javascript:void(0);" class="btn_list">목록으로 이동</a>
                            <c:if test="${ paraMap.status_apply eq 'reg' || paraMap.status_apply eq 'save' || paraMap.status_apply eq ''}" >
                            	<a href="javascript:void(0);" onclick="validataCheck('save');" class="btn_appl">작성내용 임시저장 </a>
                            	<a href="javascript:void(0);" onclick="validataCheck('submit');" class="btn_appl">사업신청서 제출 </a>
								<!-- <button type="button" id="save" onclick="validataCheck('save');">작성내용 임시저장</button><br/>
								<button type="button" id="submit" onclick="validataCheck('submit');">사업신청서 제출</button><br/> -->
							</c:if>
							<c:if test="${ paraMap.status_apply eq 'upd' }" >
								<a href="javascript:void(0);" class="btn_appl" onclick="validataCheck('update');">사업신청서 수정</a>
								<!-- <button type="button" id="submit" onclick="validataCheck('update');">사업신청서 수정</button><br/> -->
							</c:if>
                            
                        </div>
                        <div class="bottom_item">
							<c:if test="${ !empty user }" >
								<button type="button" id="save" onclick="validataCheck('save');">작성내용 임시저장</button><br/>
								<button type="button" id="submit" onclick="validataCheck('submit');">사업신청서 제출</button><br/>
							</c:if>
							<c:if test="${ empty user }" >
								<button type="button" id="submit" onclick="validataCheck('update');">사업신청서 수정</button><br/>
							</c:if>
							<button type="button" id="test" onClick="setData();">임시데이터셋팅</button><br/>
						</div>
						<!-- //page_content e:  -->
					</div>
				</div>
			</div>
			<!-- //compaVcContent e:  -->

<div class="dim-layer">
    <div class="dimBg"></div>
    <div id="layer2" class="pop-layer" style="height:500px">
        <div class="pop-container">
        <div class="pop-title"><h3>공급기관 찾기</h3><a href="javascript:void(0);" class="btn-layerClose"><span class="icon ico_close">팝업닫기</span></a></div>
            <div class="pop-conts">
                <!--content //-->
               <p class="pop-info">검색할 공급기관에 사업자번호를 입력하세요.</p>
               <div class="form-inline pop-search-box"> <input type="text" id="searchApply" name="searchApply"  placeholder="사업자번호를 입력하세요" style="width:260px"/>
               <button type="button" onClick="doSearchApply()" class="btn_step">검색</button></div>
              
               <div style="overflow-y:auto; height:300px">
               <div class="tbl_comm tbl_public" id="applyData" name="applyData" style="margin-top:10px" >
               	
               </div>

                <!--// content-->
            </div>
        </div>
    	</div>
	</div>
</div>
