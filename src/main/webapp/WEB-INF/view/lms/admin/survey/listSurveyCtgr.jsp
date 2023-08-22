<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){
	$('#pprPcd').val('S');
	
	fncCtgrTreeSetting();
	var subCheck = 0;
	var updateCheck = 0;

	$('#cancelCtgr').click(function() {
		location.reload();
	});
	$('#addCtgr').click(function(){
		if(subCheck == 0) {
			subCheck = 1;
			$('.sub_table').fadeIn();
			$('#cancelCtgr').css('display', 'inline');
			$('#updateCtgr').prop('disabled', true);
			$('#deleteCtgr').prop('disabled', true);
		}
		else{
			var ctgr_node = $("#ctgrTree").jstree('get_selected');
			var ctgr_level = ctgr_node.attr('value');
			var up_seq = ctgr_node.attr('id');
			if(ctgr_level != undefined) {
				if(ctgr_level == 1) {
					$('#upSeq').val(up_seq);
				 	$('#ctgrLvl').val(2);
					$.ajax({
			            url : "/admin/addMainSurveyCtgr.do",
			            type: "POST",
			            data: $('#frm').serialize(),
			            dataType: "json",
			            success : function(){
			            	alert_popup('서브카테고리가 등록되었습니다.');     
			                location.reload();
			            }
					});     	
				}
				else if(ctgr_level == 2) {
					$('#upSeq').val(up_seq);			
				 	$('#ctgrLvl').val(3);	
					$.ajax({			
			            url : "/admin/addMainSurveyCtgr.do",
			            type: "POST",
			            data: $('#frm').serialize(),
			            dataType: "json",
			            success : function(){
			            	alert_popup('서브카테고리가 등록되었습니다.');     
			                location.reload();
			            }
					});
				}
				else if(ctgr_level == 3) {
					alert_popup('카테고리 depth는 3까지 등록이 가능합니다.');
				}
			}
			else{	//탑메뉴로 등록되게끔 예외처리
				var ctgrConfirm = confirm('노드가 선택되어있지 않습니다. 탑메뉴로 등록하시겠습니까?');
				if(ctgrConfirm) {
					$('#upSeq').val(0);
				 	$('#ctgrLvl').val(1);
					$.ajax({
			           url : "/admin/addMainSurveyCtgr.do",
			           type: "POST",
			           data: $('#frm').serialize(),
			           dataType: "json",
			           success : function(){
			        	   alert_popup('메인카테고리가 등록되었습니다.');     
			               location.reload();
			           }
					});    
				}
				else{
					alert_popup('취소되었습니다.');
				}
			}
		}
	});

	//카테고리 수정
	$('#updateCtgr').click(function(){
		if(updateCheck == 0) {
			updateCheck = 1;
			$('.sub_table').fadeIn();
			$('#cancelCtgr').css('display', 'inline');
			$('#addCtgr').prop('disabled', true);
			$('#deleteCtgr').prop('disabled', true);
		}
		else{
			var ctgr_seq = $("#ctgrTree").jstree('get_selected').attr('id'); //선택된 노드의 카테고리 번호
			if(ctgr_seq != undefined) {
				$('#ctgrSeq').val(ctgr_seq);		
				$.ajax({
		            url : "/admin/updateSurveyCtgr.do",
		            type: "POST",
		            data: $('#frm').serialize(),
		            dataType: "json",
		            success : function(){
		            	alert_popup('카테고리가 수정되었습니다.');     
		                location.reload();
		            },
		            error : function(){
		            	alert_popup('카테고리 수정에 실패했습니다.');    
		            }
				});  
			}
			else{
				alert_popup('수정하시고 싶은 노드를 선택해주세요!');
			}
		}
	});		
	
	//카테고리 삭제
	$('#deleteCtgr').click(function(){
		var ctgr_node = $("#ctgrTree").jstree('get_selected');
		var ctgr_level = ctgr_node.attr('value');
		//선택된 노드의 카테고리 번호
		var ctgr_seq = ctgr_node.attr('id'); 		
		var child_node_list = $.jstree._focused()._get_children(ctgr_node);
		// 삭제하려는 모든 노드의 id 리스트
		var node_id_list = "'"+ctgr_node.attr('id')+"',";
		var total_child_node_cnt = 0;

		child_node_list.each(function(){
			total_child_node_cnt++;
			node_id_list += "'"+$(this).attr('id')+"',";

		var third_node_list = $.jstree._focused()._get_children($(this));

			third_node_list.each(function(){
				total_child_node_cnt++;
				node_id_list += "'"+$(this).attr('id')+"',";
			});
		});

		// 마지막 콤마 제거
		node_id_list = node_id_list.substring(0,node_id_list.length-1);

		// 하위 노드가 존재 할 경우
		if(child_node_list.length > 0){
			var result = confirm("하위 메뉴가 존재 합니다. 삭제를 하실경우 하위 메뉴도 모두 삭제가 됩니다. 진행 하시겠습니까?");
			if(!result){
				return false;
			}	
		}else{
			var result = confirm("삭제하시겠습니까?");
			if(!result){
				return false;
			}
		}
		
		$.ajax({
            url : "/admin/deleteSurveyCtgr.do",
            type: "POST",
            data: {ctgr_seq : ctgr_seq},	
            dataType: "json",
            success : function(){
            	alert_popup('카테고리가 삭제되었습니다.');     
                location.reload();
            },
            error : function(){
            	alert_popup('카테고리 삭제에 실패했습니다.');    
            }
		});  			
	});		
});

function fncCtgrTreeSetting() {	
	$.ajax({
		type:'POST',
		url:'/admin/listSurveyCtgr.do',
		success:function(data) {
			//설문조샤 카테고리 가져오기
			var strSurveyCtgr = data.strSurveyCtgr;
			if(strSurveyCtgr != undefined) {
				$('#ctgrTree').html(strSurveyCtgr);
				$('#ctgrTree').jstree({
					'plugins' : ['themes', 'html_data', 'ui'],
				}).bind("select_node.jstree",function(e,data){
					var ctgr_seq = $("#ctgrTree").jstree('get_selected').attr('id');
						$.ajax({
				            url : "/admin/getSurveyCtgr.do",
				            type: "POST",
				            data: {'ctgr_seq' : ctgr_seq},	
				            dataType: "json",
				            success : function(result){
				            
									$('input[name=ctgrnm]').attr('value',result.data.ctgrnm);
						           	$('input[name=ctgr_cmmt]').attr('value',result.data.ctgr_cmmt);
									
						           	//사용유무
						           	if(result.data.useyn == 'Y'){
						           		$("#useYn").val('Y').attr("selected", "selected");
						           	}else{
						           		$("#useYn").val('N').attr("selected", "selected");						           		
						           	}
				        }
					});     
				});
			}
		}
	});
}
</script>
<form action="#" id="frm" name="frm" method="post">
  	<input type="hidden" id="ctgrSeq" name="ctgr_seq" class="ctgr_seq" value="${ paraMap.ctgr_seq }">
  	<input type="hidden" id="pprPcd" name="ppr_pcd" class="ppr_pcd" value="${ paraMap.ppr_pcd }">  
  	<input type="hidden" id="ctgrLvl" name="ctgr_lvl" class="ctgr_lvl" value="${ paraMap.ctgr_lvl }">  	
  	<input type="hidden" id="upSeq" name="up_seq" class="up_seq" value="${ paraMap.up_seq }">  	
	<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />	
	<div class="contents">
	  <div class="content_wrap">
	  		<!-- 카테고리 트리 -->
	  		<div class="cate_box fl wp40">
	  			<div class="tree_st">
	  				<div id="ctgrTree" class="menuTree" style="border: solid 1px #BBB;"></div> 
	  			</div>
	  		</div>
			<div class="fr wp60">
				<div class="table2">
					<table class="main_table">
					<colgroup><col width="23%"/><col width="57%"/></colgroup>					
						<tbody class="line">	
							<tr>
								<th>카테고리 명</th>
								<td class="left">
									<input type="text" id="ctgrNm" class="form-control w300" name="ctgrnm" value=""/>
								</td>
							</tr>
						</tbody>
					</table>
					<table class="sub_table" hidden="true">
						<colgroup><col width="23%"/><col width="57%"/></colgroup>
						<tbody class="line">
						<tr>
							<th>카테고리 설명</th>
							<td class="form-inline left">
								<input type="text" id="ctgrCmmt" class="form-control w300" name="ctgr_cmmt" value=""/>
							</td>
						</tr>	
						<tr>
							<th>사용유무</th>
							<td class="form-inline left">
								<select id="useYn" class="form-control w300" name="useyn">
									<option value="Y">사용</option>
									<option value="N">미사용</option>									
								</select>
							</td>
						</tr>
						</tbody>												
					</table>
					<!-- 버튼 오른쪽 -->
					<div class="btnList alignRight mTop15">
							<button type="button" id="cancelCtgr" class="btn btn-primary btn-sm" style="display: none">취소</button>
							<button type="button" id="addCtgr" class="btn btn-primary btn-sm">등록</button>							
							<button type="button" id="updateCtgr" class="btn btn-primary btn-sm">수정</button>
							<button type="button" id="deleteCtgr" class="btn btn-primary btn-sm">삭제</button>							
					</div>					
				</div>
			</div>  	
	  </div>
	</div>
</form>
		