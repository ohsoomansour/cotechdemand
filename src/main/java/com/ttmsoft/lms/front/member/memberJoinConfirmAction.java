package com.ttmsoft.lms.front.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ttmsoft.toaf.object.DataMap;

@RestController
@RequestMapping(value = "/front")
public class memberJoinConfirmAction {
	@Autowired
	private MemberService memberService;
	/*
	@GetMapping("/joinAgreementConfirm/{seqno}")
	public ResponseEntity<?> confirmJoinApproved(@PathVariable("seqno") DataMap seqno) throws Exception 
	{
	
		return new ResponseEntity<Map>(memberService.getJoinApprovedFlag(seqno));
	}
	*/
		
}
		

