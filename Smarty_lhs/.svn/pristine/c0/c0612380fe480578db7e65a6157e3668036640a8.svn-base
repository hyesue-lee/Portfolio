package com.lhs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.lhs.service.AttFileService;
import com.lhs.service.BoardService;
import com.lhs.util.FileUtil;

@Controller
public class BoardController {

	@Autowired BoardService bService;
	@Autowired AttFileService attFileService;
	@Autowired FileUtil fileUtil;

	
	private String typeSeq = "2";
	
	@RequestMapping("/board/list.do")
	public ModelAndView list(@RequestParam HashMap<String, String> params){
		ModelAndView mv = new ModelAndView();
		System.out.println("b list params check:"+ params);
		if(!params.containsKey("typeSeq")) {
			params.put("typeSeq", this.typeSeq);
		}
		if(params.containsKey("searchType")) {
			mv.addObject("searchType",params.get("searchType")); 
		}
		if(params.containsKey("searchText")) {
			mv.addObject("searchText",params.get("searchText")); 
		}
		
		mv.setViewName("board/list");
		// 현재 페이지
		int currentPage = Integer.parseInt(params.containsKey("page") ? params.get("page"):"1");
		
		// 페이지에 보여줄 게시글 수
		int rows = Integer.parseInt(params.containsKey("rows")?params.get("rows"):"7");
		
		// 총 게시글 수 
		int total = bService.getTotalArticleCnt(params);
		
		
		// 총 페이지 수 계산
		int totalPage =  (int) Math.ceil( total / (double) rows);
		
		// 시작 게시글 번호
		int start = ((currentPage - 1) * rows);
		
		params.put("start", String.valueOf(start));
		params.put("rows", String.valueOf(rows));
		params.put("sidx", "board_seq");
		params.put("sord", "desc");
		
		ArrayList<HashMap<String, Object>> list = bService.list(params);
		
		// 기본 블럭 수 10
		int blockSize = Integer.parseInt(params.containsKey("blockSize")?params.get("blockSize"):"10");;
		int startBlockNo = (currentPage - 1) / blockSize * blockSize + 1;
		int endBlockNo = (currentPage - 1) / blockSize * blockSize + blockSize;
		endBlockNo = (endBlockNo >= totalPage)?totalPage:endBlockNo;
		
		mv.addObject("test", "t");
		mv.addObject("totalPage", totalPage);
		mv.addObject("page", currentPage);
		mv.addObject("blockSize", blockSize);
		mv.addObject("startBlockNo", startBlockNo);
		mv.addObject("endBlockNo", endBlockNo);
		mv.addObject("list", list);
		mv.addObject("typeSeq", params.get("typeSeq"));
		
		return mv;
	}
	
	
	//글쓰기 페이지로 	
	@RequestMapping("/board/goToWrite.do")
	public ModelAndView goToWrite(@RequestParam HashMap<String, Object> params) {
		System.out.println("gggggggg"+ params);
		if(!params.containsKey("typeSeq")) {
			params.put("typeSeq", this.typeSeq);
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/board/write");
		return mv;
	}
	
	@RequestMapping("/board/write.do")
	@ResponseBody
	public HashMap<String, Object> write(@RequestParam HashMap<String, Object> params, MultipartHttpServletRequest mReq) {
		
		if(!params.containsKey("typeSeq")) {
			params.put("typeSeq", this.typeSeq);
		}
		
		System.out.println("wwwwwwwwwwwwrite params:" + params);
		
		List<MultipartFile> mFiles = mReq.getFiles("attFiles");
		
		for(MultipartFile mFile : mFiles) {
			if(mFile.getSize()!=0) { // 파일존재시 
				params.put("hasFile", "Y"); 
				break;
			}else {// ** 0 안넣어주면 null로 감. 
				params.put("hasFile", "N");
			}
			
			System.out.println("ffffffff check1:"+ params.get("hasFile"));
		}
		
		System.out.println("ffffffff check2:"+ params.get("hasFile"));
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		int result = bService.write(params,mFiles);
		String msg = (result == 1) ? "성공" : "실패";
		
		map.put("result", result);
		map.put("msg", msg);
		
		map.put("boardSeq", params.get("boardSeq"));
		System.out.println("are you sure"+params.get("boardSeq"));
		return map;
	}
	
	@RequestMapping("/board/read.do")
	public ModelAndView read(@RequestParam HashMap<String, Object> params) {
		if(!params.containsKey("typeSeq")) {
			params.put("typeSeq", this.typeSeq);
		}
		ModelAndView mv = new ModelAndView();
		
		System.out.println("read params:" + params);
		
		// 글 상세조회 select 
		HashMap<String, Object> boardInfo = bService.read(params);
		//조회정보로 첨부파일 여부 조사 
		System.out.println("has file check -read.do" + boardInfo.get("has_file"));

		if(boardInfo.get("has_file").equals("Y")) {// 첨부파일이 존재하는 글이면 
			//첨부파일 조회 Service 호출. select by typeSeq, boardSeq 
			List<HashMap<String, Object>> attFiles = attFileService.readAttFiles(params);
			mv.addObject("attFiles" , attFiles);	
		}
		
		mv.addObject("page", params.get("page"));
		mv.addObject("boardInfo", boardInfo);
		System.out.println("read-boardInfo"+ boardInfo);
	
		mv.setViewName("/board/read");
		

		return mv;
	}
	
	
	@RequestMapping("/board/downloadFile.do")
	@ResponseBody
	public byte[] downloadFile(@RequestParam int fileIdx, HttpServletResponse rep) { //** Response응답 받을시 @Responsebody 필요!! 
		//1.받아온 파람의 파일 pk로 파일 전체 정보 불러온다. -attFilesService필요! 
		HashMap<String,Object> fileInfo = attFileService.readAttFileByPk(fileIdx);
		
		//2. 받아온 정보를 토대로 물리적으로 저장된 실제 파일을 읽어온다.
		byte[] fileByte = null;
		
		if(fileInfo == null) { //지워진 경우 
			
		}else {//파일 존재하면 
			//파일 읽기 메서드 호출 
			fileByte = fileUtil.readFile(fileInfo);
			
		}
		
		//돌려보내기 위해 응답(httpServletResponse rep)에 정보 입력. **** 응답사용시 @ResponseBody 필요 ! !
		//Response 정보전달: 파일 다운로드 할수있는 정보들을 브라우저에 알려주는 역할 
		rep.setHeader("Content-Disposition", "attachment; filename=\""+fileInfo.get("file_name") + "\""); //파일명
		rep.setContentType(String.valueOf(fileInfo.get("file_type"))); //확장자 
		rep.setContentLength(Integer.parseInt(String.valueOf(fileInfo.get("file_size")))); // 파일사이즈 
		rep.setHeader("pragma", "no-cache");
		rep.setHeader("Cache-Control", "no-cache");
		
		return fileByte;
	}
	
	
	
	//수정  페이지로 	
		@RequestMapping("/board/goToUpdate.do")
		public ModelAndView goToUpdate(@RequestParam HashMap<String, Object> params, HttpSession session) {
			
			ModelAndView mv = new ModelAndView();
			
			if(!params.containsKey("typeSeq")) {
				params.put("typeSeq", this.typeSeq);
			}

			System.out.println("uuuuuuuuuu"+ params);
			
			if(session.getAttribute("memberId") != null) {// 로그인 상태 
			//본인 체크. 
			
			//해당 글 정보 받기 위해 read 
			HashMap<String, Object> boardInfo = bService.read(params);
			mv.addObject("boardInfo" , boardInfo);
			System.out.println("fuuuuuuuuuck");
			System.out.println(boardInfo);
			if(boardInfo.get("has_file").equals("Y")) {//첨부파일 존재하면 
				List<HashMap<String, Object>> fileInfos = attFileService.readAttFiles(params); 
				mv.addObject("attFiles", fileInfos);
				
			}

			mv.setViewName("/board/update");
			return mv;
		}else { // 로그인 세션 풀렸을때,  -> 잘못된 접근.. -> 공통화 
			mv.setViewName("common/error"); // 잘못된 접근시 error 페이지 보여준다. 
			
			mv.addObject("msg" , "로그인 하세요");
			mv.addObject("nextLocation","/index.do");
			
		}
		return mv;
	
		}
		
		@RequestMapping("/board/update.do")
		@ResponseBody // !!!!!!!!!!!! 비동기 응답 
		public HashMap<String, Object> update(@RequestParam HashMap<String,Object> params, MultipartHttpServletRequest mReq) {

			if(!params.containsKey("typeSeq")) {
				params.put("typeSeq", this.typeSeq);
			}
			
			System.out.println("updateParamssssssss:" + params);
			
			
			//1. 첨부파일 유무 확인 : MultipartFile  
					List<MultipartFile> mFiles = mReq.getFiles("attFiles");
			
				//1-1) 원래 첨부파일 없던 글에 첨부파일을 추가하는 경우 has_file 0 -> 1 변경해주어야함.. 
					if(params.get("hasFile").equals("N")) { // 첨부파일 없는 글이면 
						
						//새로 추가된 파일이 존재하는지 이름 뒤져서 검사한다.
						for(MultipartFile mFile : mFiles) {
							if(!mFile.getOriginalFilename().equals("")) { //파일 이름 존재하면 파일 추가해준 것이므로 
								
								params.put("hasFile", "Y");// hasFile값을 1로 바꿔서 put 해준다. 
								break;
							}
						}
					}
				//1-2) 기존에 첨부파일 있던 글에 첨부파일 수정 된 경우. has file 1 건들필요 없고, 첨부파일 삭제시 hasFile = 0이 되므로 건들필요없음..   
			
	
			//비동기식은 HashMap에 정보담아 return 한다 !! 
			HashMap<String, Object> map = new HashMap<String, Object>();
				//2. 글 정보 수정 service 호출.
				int result = bService.update(params,mFiles); 
				//쿼리성공: 1 / 실패 : 0 
				String msg = (result == 1) ? "성공" : "실패";

			//비동기 리턴할맵에 필요정도(쿼리 결과, 메세지, 글번호) PUT !!  
					//like addObject of ModelandView 기능 .. 
			map.put("result", result);
			map.put("msg", msg);
			map.put("boardSeq", params.get("boardSeq"));

			return map;
		}
		
		@RequestMapping("/board/delete.do")
		@ResponseBody
		public HashMap<String, Object> delete(@RequestParam HashMap<String, Object> params, HttpSession session) {

			if(!params.containsKey("typeSeq")) {
				params.put("typeSeq", this.typeSeq);
			}
			//비동기 리턴해줄 맵 생성
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			System.out.println("dddddddddd params con:"+params);

			if(session.getAttribute("memberId") != null) { // 세션에 값있을 : 로긴상태일때만 
				
				//1. 글 정보 검사 - has_file 추출.  
				HashMap<String, Object> boardInfo = bService.read(params);
				params.put("hasFile", boardInfo.get("has_file"));
				//삭제 쿼리 호출 
				int result = bService.delete(params);
				
				//쿼리결과따라 msg 값 대입 
				String msg = (result == 1 ? "성공" : "실패");
				
				//필요정보 map에 put 
				map.put("msg", msg);
				map.put("result", result);
				map.put("typeSeq", params.get("typeSeq"));
				

			}else {// 로그인 세션 풀렸을때,  -> 잘못된 접근.. -> 공통화 
//				mv.setViewName("common/error"); // 잘못된 접근시 error 페이지 보여준다. 	
//				mv.addObject("msg" , "로그인 하세요");
//				mv.addObject("nextLocation","/index.do");
			}
		return map; // 비동기: map return 
		}
		
		@RequestMapping("/board/deleteAttFile.do")
		@ResponseBody
		public HashMap<String, Object> deleteAttFile(@RequestParam HashMap<String, Object> params) {

			if(!params.containsKey("typeSeq")) {
				params.put("typeSeq", this.typeSeq);
			}
			//비동기 리턴해줄 맵 생성
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			//첨부파일 삭제 쿼리 호출 
			boolean result = bService.deleteAttFile(params); // service에서 hasFile정보 update 
			
			//쿼리결과따라 msg 값 대입 
			String msg = (result == true ? "성공" : "실패");
			
			//필요정보 map에 put 
			map.put("msg", msg);
			map.put("result", result);
			map.put("typeSeq", params.get("typeSeq"));
			map.put("boardSeq", params.get("boardSeq"));
			
			
			return map;
		} 
		
		
		
}
