<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){
	<c:forEach var="choice" items="${ choice }">
		console.log('${ choice.percent }');
	</c:forEach>
});

</script>
<form action="#" id="frm" name="frm" method="post">
<div class="contents">
  <div class="content_wrap">  
		<div class="table2 mTop10">
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody>
		  		<!-- 설문 제목-->		  	
		  		<tr>
		  			<th>설문 제목</th>
		  			<td class="left">
		  				${ mng.ppr_title }
		  			</td>
		  		</tr>
		  		<!-- 설문 기간 -->				  		
		  		<tr>
		  			<th>설문기간</th>
					<td class="left form-group">
						${ mng.eval_sday } ~ ${ mng.eval_eday }
					</td>					
		  		</tr>	
		  		<!-- 총 참여 인원-->				  		
		  		<tr>
		  			<th>참여인원</th>
					<td class="left form-group">
						${ mng.apply_cnt } 명
					</td>					
		  		</tr>			  		
		  	</tbody>
		  </table>					  				  					  		  		  		 		  		  				  				  				  		
		<!-- 객관식  / OX-->		  		
 		<c:forEach var="queO" items="${ queO }" varStatus="status">
 			<div class="well mTop10">
 				<table>
					<colgroup>
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody>
				  		<tr>
	 						<th>문항</th>
	 						<td class="left">${ queO.que_title }</td>
	 					</tr>
	 					<tr>
	 						<th>결과</th>
	 						<td  class="left">
	 						 	<c:forEach var="choice" items="${ choice }">
	 						  		<c:if test="${ queO.que_seq eq choice.que_seq }">
	 									${ choice.item_title } ${ choice.cnt } / ${ choice.tot } 명
		 								<div class="progress">
										  <div class="progress-bar" role="progressbar" style="width: ${ choice.percent }%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">${ choice.percent }%</div>
										</div>
	 								</c:if>
								</c:forEach>	
 							</td>
 						</tr>
 					</tbody>
				</table>
			</div>		
		</c:forEach>  	
 		<!-- 객관식  / OX-->		  		
 		<c:forEach var="queS" items="${ queS }" varStatus="status">
 			<div class="well mTop10">
 				<table>
					<colgroup>
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody>
				  		<tr>
	 						<th>문항</th>
	 						<td class="left">${ queS.que_title }</td>
	 					</tr>
	 					<tr>
	 						<th>결과</th>
	 						<td class="left">
	 						  	<c:forEach var="subjective" items="${ subjective }">
	 						  		 <c:if test="${ queS.que_seq eq subjective.que_seq }">
										${ subjective.apl_ans }<br>
									</c:if>
								</c:forEach>
	 						</td>
 						</tbody>
					</table>
				</div>		
			</c:forEach>  
		</div>
	</div>
</div>
</form>