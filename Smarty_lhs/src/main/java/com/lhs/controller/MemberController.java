package com.lhs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.lhs.exception.PasswordMissMatchException;
import com.lhs.exception.UserNotFoundException;
import com.lhs.service.MemberService;


@Controller
public class MemberController {
	
	@Autowired
	MemberService mService;
	
	@Value("#{config['site.context.path']}")
	String ctx;
	
	Logger logger = Logger.getLogger(MemberController.class);
	
	@RequestMapping("/member/goLoginPage.do")
	public String goLogin() {
		return "member/login";
	}
	
	@RequestMapping("/member/goRegisterPage.do")
	public String goRegisterPage() {
		return "member/register";
	}
	
	@RequestMapping("/member/checkId.do")
	@ResponseBody
	public HashMap<String, Object> checkId(@RequestParam HashMap<String, String> params){
		logger.debug("/member/checkId.do params : " + params);
		
		int cnt = mService.checkId(params);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("cnt", cnt);
		map.put("msg", cnt==1? "중복된 ID 입니다.":"");
		
		return map;
	}
	
	@RequestMapping("/member/join.do")
	@ResponseBody
	public HashMap<String, Object> join(@RequestParam HashMap<String, String> params){
		logger.debug("/member/join.do params : " + params);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		int cnt = mService.join(params);
		map.put("cnt", cnt);
		map.put("msg", cnt==1?"회원 가입 완료!":"회원 가입 실패!");
		map.put("nextPage", cnt==1?"/member/goLoginPage.do" : "/member/goRegisterPage.do");
		return map;
	}
	
	@RequestMapping("/member/logout.do")
	public ModelAndView logout(HttpSession session){
		session.invalidate();
		ModelAndView mv = new ModelAndView();
		RedirectView rv = new RedirectView(ctx+"/index.do");
		mv.setView(rv);
		
		return mv;
	}
	
	@RequestMapping("/member/login.do")
	@ResponseBody
	public HashMap<String, Object> login(@RequestParam HashMap<String, String> params, HttpSession session){
		logger.debug("/member/login.do params : " + params);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			HashMap<String, Object> member = mService.login(params);
			session.setAttribute("memberId", member.get("memberId"));
			session.setAttribute("memberIdx", member.get("memberIdx"));
			session.setAttribute("memberType", member.get("memberType"));
			session.setAttribute("memberNick", member.get("memberNick"));
			session.setAttribute("memberName", member.get("memberName"));
			
			map.put("nextPage", "/index.do");
		} catch (UserNotFoundException | PasswordMissMatchException e) {
			e.printStackTrace();
			logger.error(e);
			map.put("nextPage", "/index.do");
			map.put("msg", e.getMessage());
		}
		return map;
	}
	
	

	
	@RequestMapping("/admin/memberList.do")
	@ResponseBody //비동기식 호출
	public HashMap<String, Object> memberList(@RequestParam HashMap<String, Object> params) {
		logger.debug("/aaaaaaaaaaadmin/memberList.do : " + params);
		//params: {_search=false, nd=1539148779684, rows=10, page=1, sidx=memberIdx, sord=desc}

		
			//1. 한페이지에 보일 글 수 
				int rows = Integer.parseInt(String.valueOf(params.get("rows")));
				//2.현재 페이지 
				int currentPage = Integer.parseInt(String.valueOf(params.get("page")));
				//3.전체 회원수 구하기 
				int totalMember = mService.totalMemberCnt(params);
				//4. 총페이지
				int totalPage = (int) Math.ceil(totalMember / (double)rows) ;
				//시작인덱스(0번부터) 
		
				int startIndex= (currentPage-1) * rows;
				System.out.println("wtf? startidx: "+startIndex);
				
				//go to DB 
				params.put("start", startIndex);
				
				//모든 회원 셀렉
				List<HashMap<String,Object>> memberList = new ArrayList<HashMap<String,Object>>();
				memberList = mService.memberList(params);
				
				//go to  JSP 
				
		
				HashMap<String,Object> result = new HashMap<String,Object>();
				//정해진  키 이름으로 넘겨주기.. 
				result.put("page", params.get("page")); //현재 페이지 
				result.put("rows", memberList); // 불러온 회원목록 
				result.put("total", totalPage);// 전체 페이지 
				result.put("records", totalMember); //전체 회원수 
				
				
		return result;

	}
	
	@RequestMapping("/member/delMember.do")
	@ResponseBody
	public HashMap<String,Object> delMember(@RequestParam HashMap<String, Object> params){
	
		logger.debug("/member/delMember.do : " + params);
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		int result = mService.delMember(params);

		map.put("msg", (result == 1) ? "삭제되었습니다.":"삭제 실패!");
		map.put("result",result);

//		 Map return하면 js의 오브젝트{}로 넘어간다.  
//		 {msg: "삭제되었습니다.", result: 1}
//		 여기서 값을 꺼내서 msg띄움. 
		
		return map;
	
	}
	
}
