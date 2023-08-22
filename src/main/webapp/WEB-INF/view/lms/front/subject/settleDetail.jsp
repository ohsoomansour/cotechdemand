<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1">
<script>
var before_btn = "#btn_list";
window.onload = function(){
	$('#bank_code').val('${paraMap.settledata.bank_code}').prop("selected",true);
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
	//여기까지삭제
	console.log(list);
	 var options = {
    	fmstSeq: ${paraMap.settledata.fmst_seqno},
    	//fmstSeq: 11,
        types: list,
        callback: function(data){
        	if(data == 0 || data == undefined){
        		alert("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
		    	return false;
		    	}
	    	doSettleSubmit(data);
		},
    };
    window.uploadSrc.create($('#uploadArea'), options);	    
    var subject_status = "${paraMap.settledata.subject_proc_status }";
    if(subject_status == '50'){
    	$('#add-button-row').remove();
        }
    
}

//유효성체크
function validataCheck(stat,btn){
	console.log("validateCheck")
	//null체크 후 
	<c:if test="${paraMap.settledata.settle_type eq 'A10'}" >
		var check = confirm("[선금신청 자료]를 제출하시겠습니까? ")
	</c:if>
	<c:if test="${paraMap.settledata.settle_type eq 'B10'}" >
		var check = confirm("[잔금신청 자료]를 제출하시겠습니까? ")
	</c:if>
	<c:if test="${paraMap.settledata.settle_type eq 'B20'}" >
		var check = confirm("[잔금반납 자료]를 제출하시겠습니까? ")
	</c:if>
	
		if (check == true) {
			uploadFile(stat,btn)
			
		}
	
}
function uploadFile(stat,btn){
	status = stat;
	before_btn = btn;
	var empty = document.getElementsByClassName('file-empty')[0];
	//console.log(empty);
	if(empty==undefined){
		//파일전송후 공고등록
		uploadSrc.startUpload();
	}
	else{
		//alert("")
		//공고등록
		doSettleSubmit(stat);
	}
}
//서명하기
function doSettleSubmit(fmst_seqno){
	var url = "/subject/settleSubmit.do"
		var form = $('#frm')[0];
		var data = new FormData(form);
		var total_cost = $('#costSum').text();
		data.append("total_cost_items",total_cost.substring(0,total_cost.length-1));
		data.append("fmst_seqno",fmst_seqno);
		data.append("subject_proc_status",status);
		//var data = $('#frm').serialize();
			$.ajax({
			       url : url,
			       type: "post",
			       processData: false,
			       contentType: false,
			       data: data,
			       dataType: "json",
			       success : function(res){
				      if(res.result > 3){
				    	  alert('제출 되었습니다',res);
				    	  goList();
					      }
				      else{
				    	  alert("실패되었습니다.");
					      }
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
function addRow() {
    var tbody = document.getElementById('tbody');
    // var row = tbody.insertRow(0); // 상단에 추가
    var row = tbody.insertRow( tbody.rows.length-1 ); // 하단에 추가
    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);
    cell1.innerHTML = "<input type = 'text' id='item' name='item' />";
    cell2.innerHTML = "<input type = 'text' id='desc' name='desc' />";
    cell3.innerHTML = "<input type = 'number' id='cost' name='cost' onchange='doSum();' />";
  }

  function deleteRow() {
    var tbody = document.getElementById('tbody');
    if (tbody.rows.length < 1) return;
    // tbody.deleteRow(0); // 상단부터 삭제
    tbody.deleteRow( tbody.rows.length-2 ); // 하단부터 삭제
  }
 function doSum(){
	var costLen = $('input[name=cost]').length;
	console.log("cost",cost);
	var arrCost = new Array(costLen);
	var costSum = 0;
	for(var i=0; i<costLen; i++){
		arrCost[i] = $("input[name=cost]").eq(i).val()*1;
		costSum+= arrCost[i];
		}
	$("#costSum").text(costSum+"원");
	 }
 function goList(){
	 window.location.href="/subject/settleList.do";
	}
</script>
<form id="frm" name="frm" action ="/subject/settleSubmit.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<c:if test="${paraMap.settledata.settle_type eq 'A10'}" >
					<h3 class="tit_corp">사업비 신청 상세 (선금신청)</h3>
				</c:if>
				<c:if test="${paraMap.settledata.settle_type eq 'B10'}" >
					<h3 class="tit_corp">사업비 신청 상세 (잔금신청)</h3>
				</c:if>
				<c:if test="${paraMap.settledata.settle_type eq 'B20'}" >
					<h3 class="tit_corp">사업비 신청 상세 (잔금반환)</h3>
				</c:if>
				
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<h4 class="subject_corp">과제정보</h4>
				
				<input type="hidden" id="project_seqno" name="project_seqno" value="${paraMap.project_seqno }"/>
				<input type="hidden" id="subject_seqno" name="subject_seqno"  value="${paraMap.subject_seqno }"/>
				<input type="hidden" id="settle_type" name="settle_type"  value="${paraMap.settledata.settle_type }"/>
				<div class="box_info2">
					<dl>
						<dt>협약번호</dt>
						<dd>${paraMap.subject_ref }</dd>
					</dl>
					<dl>
						<dt>사업명</dt>
						<dd>${paraMap.project_title }</dd>
					</dl>
					<dl>
						<dt>과제명</dt>
						<dd>${paraMap.subject_title }</dd>
					</dl>
					<dl class="col4">
						<dt>수요기업</dt>
						<dd>${paraMap.dcdata.biz_name }</dd>
						<dt>공급기업</dt>
						<dd>${paraMap.scdata.biz_name }</dd>
					</dl>
					<dl class="col4">
						<dt>협약기간</dt>
						<dd>${paraMap.subject_sdate } ~ ${paraMap.subject_edate }</dd>
						<dt>진행상태</dt>
						<dd>
						 <c:if test="${paraMap.subject_proc_step eq '110'}">
							<span class="lb lb_apply">사업신청 단계</span>
						</c:if>
						<c:if test="${paraMap.subject_proc_step eq '120'}">
							<span class="lb lb_apply">협약체결 단계</span>
						</c:if>  
						<c:if test="${paraMap.subject_proc_step eq '130'}">
							<span class="lb lb_apply">권한부여 단계</span>
						</c:if>  
						<c:if test="${paraMap.subject_proc_step eq '141'}">
							<span class="lb lb_apply">선금신청 단계</span>
						</c:if>
						<c:if test="${paraMap.subject_proc_step eq '142'}">
							<span class="lb lb_apply">잔금신청 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '143'}">
							<span class="lb lb_apply">잔금반납 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '151'}">
							<span class="lb lb_apply">진도점검 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '152'}">
							<span class="lb lb_apply">현장실태조사 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '160'}">
							<span class="lb lb_apply">설문조사 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '170'}">
							<span class="lb lb_apply">최종평가 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '180'}">
							<span class="lb lb_apply">추적조사 단계</span>
						</c:if> 
						</dd>
					</dl>
				</div>
				

			</div>
			<!-- <div class="area_cont area_cont2">
                 <div class="subject_corp">
                     <h4>협약내용</h4>
                 </div>
                 	[상세보기]
             </div> -->
             <div class="area_cont area_cont2" >
                 <div class="subject_corp">
                     <h4>협약금액</h4>
                 </div>
                 
				<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption >사업수행 사업비 협약금액</caption>
							<colgroup>
								<col>
								<col>
								<col>
								<col>
							</colgroup>
							<thead>
								<tr>
									<th>총사업비</th>
									<th>정부지원금</th>
									<th>수요기업 자부담금</th>
									<th>부가가치세</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>${paraMap.voucher_total }</td>
									<td>${paraMap.gov_cost }</td>
									<td>${paraMap.com_cost }</td>
									<td>${paraMap.vat_cost }</td>
								</tr>
							</tbody>
						</table>
				</div>
				<div class="tbl_comm tbl_public">
						<table class="tbl">
							<c:if test="${paraMap.settledata.settle_type eq 'A10'}" >
								<caption class="caption_hide">사업수행 사업비 선금신청</caption>
							</c:if>
							<c:if test="${paraMap.settledata.settle_type eq 'B10'}" >
								<caption class="caption_hide">사업수행 사업비 잔금신청</caption>
							</c:if>
							<c:if test="${paraMap.settledata.settle_type eq 'B20'}" >
								<caption class="caption_hide">사업수행 사업비 잔금반납</caption>
							</c:if>
							<colgroup>
								<col>
								<col>
								<col>
								<col>
							</colgroup>
							<thead>
								<tr>
									<th><label for="bank_code">거래은행</label></th>
									<th >
										<select class="select_normal " name="bank_code" id="bank_code" title="은행리스트">
											<option value="001" title="한국은행">한국은행</option>
											<option value="002" title="산업은행">산업은행</option>
											<option value="003" title="기업은행">기업은행</option>
											<option value="004" title="KB국민은행">KB국민은행</option>
											<option value="007" title="수협은행">수협은행</option>
											<option value="011" title="NH농협은행">NH농협은행</option>
											<option value="012" title="농·축협">농·축협</option>
											<option value="020" title="우리은행">우리은행</option>
											<option value="023" title="SC제일은행">SC제일은행</option>
											<option value="027" title="한국씨티은행">한국씨티은행</option>
											<option value="031" title="대구은행">대구은행</option>
											<option value="032" title="부산은행">부산은행</option>
											<option value="034" title="광주은행">광주은행</option>
											<option value="035" title="제주은행">제주은행</option>
											<option value="037" title="전북은행">전북은행</option>
											<option value="039" title="경남은행">경남은행</option>
											<option value="045" title="새마을은행">새마을은행</option>
											<option value="048" title="신협">신협</option>
											<option value="050" title="저축은행">저축은행</option>
											<option value="081" title="하나은행">하나은행</option>
											<option value="088" title="신한은행">신한은행</option>
											<option value="089" title="케이뱅크">케이뱅크</option>
											<option value="090" title="카카오뱅크">카카오뱅크</option>
											<option value="092" title="토스혁신준비법인">토스혁신준비법인</option>
											<option value="102" title="대신저축은행">대신저축은행</option>
											<option value="103" title="에스비아이저축은행">에스비아이저축은행</option>
											<option value="104" title="에이치케이저축은행">에이치케이저축은행</option>
											<option value="105" title="웰컴저축은행">웰컴저축은행</option>
											<option value="106" title="신한저축은행">신한저축은행</option>
										</select>
									</th>
									<th>정산신청금액</th>
									<th>
										<input type = "text" id="total_cost_request" name="total_cost_request" title="정산신청금액" value="${paraMap.settledata.total_cost_request }"/>
									</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>계좌번호</td>
									<td><input type = "text" id="account_no" name="account_no" title="계좌번호" value="${paraMap.settledata.account_no }"/></td>
									<td>예금주명</td>
									<td><input type = "text" id="depositor" name="depositor" title="예금주명" value="${paraMap.settledata.depositor }"/></td>
								</tr>
							</tbody>
						</table>
				</div>
				<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption >사업수행 사업비 협약금액3</caption>
							<colgroup>
								<col>
								<col>
								<col>
							</colgroup>
							<thead>
								<tr>
									<th>비목(세목)</th>
									<th>세부산출내역</th>
									<th>소요금액</th>
								</tr>
							</thead>
							<tbody id="tbody">
									<c:if test="${empty paraMap.listsettledata }">
										<tr>
											<td><input type = "text" id="item" name="item" title="비목"/></td>
											<td><input type = "text" id="desc" name="desc" title="세부산출내역"/></td>
											<td><input type = "number" id="cost" name="cost" onchange="doSum();" title="소요금액"/></td>
										</tr>
									</c:if>
									<c:if test="${!empty paraMap.listsettledata}">
										<c:forEach var="list" items="${paraMap.listsettledata }" varStatus="status">
											<tr>
												<td><input type = "text" id="item" name="item" value="${list.item }" title="비목"/></td>
												<td><input type = "text" id="desc" name="desc" value="${list.settle_desc }" title="세부산출내역"/></td>
												<td><input type = "number" id="cost" name="cost" onchange="doSum();" value="${list.cost }" title="소요금액"/></td>
											</tr>
										</c:forEach>
									</c:if>
								<tr>
									<th>합계 </th>
									<th colspan="2"><span id="costSum" >${paraMap.settledata.total_cost_items}원</span></th>
								</tr>
							</tbody>
						</table>
						<div class="wrap_btn _center">
							<a href="javascript:void(0);" onclick="addRow();" class="btn_appl" title="세부항목 추가하기">세부항목 추가하기</a>
							<a href="javascript:void(0);" onclick="deleteRow();" class="btn_appl" title="세부항목 삭제하기">세부항목 삭제하기</a>
						</div>
				</div>
             </div>
			<div class="area_cont area_cont2">
                 <div class="subject_corp">
                     <h4>제출서류</h4>
                 </div>
                 <div  id="uploadArea"></div>
             </div>
			
			<div class="wrap_btn _center">
				<a href="/subject/settleList.do"  class="btn_appl" id="btn_list">목록으로 이동</a>
				<c:if test="${paraMap.settledata.subject_proc_status eq '00' ||paraMap.settledata.subject_proc_status eq '10' 
				||paraMap.settledata.subject_proc_status eq '20' || paraMap.settledata.subject_proc_status eq '80'  }">
					<c:if test="${paraMap.settledata.settle_type eq 'A10'}" >
						<a href="javascript:void(0);" onclick="validataCheck('20','#btn_submit_a10')" class="btn_appl" id="btn_submit_a10">[선금신청]</a>
					</c:if>
					<c:if test="${paraMap.settledata.settle_type eq 'B10'}" >
						<a href="javascript:void(0);" onclick="validataCheck('20',,'#btn_submit_b10')" class="btn_appl" id="btn_submit_b10">[잔금신청]</a>
					</c:if>
					<c:if test="${paraMap.settledata.settle_type eq 'B20'}" >
						<a href="javascript:void(0);" onclick="validataCheck('20',,'#btn_submit_b20')" class="btn_appl" id="btn_submit_b20">[잔금반납]</a>
					</c:if>
					
				</c:if>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</form>
