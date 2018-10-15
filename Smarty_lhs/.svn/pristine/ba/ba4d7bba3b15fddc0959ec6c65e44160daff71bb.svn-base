package com.lhs.service.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.lhs.dao.AttFileDao;
import com.lhs.dao.BoardDao;
import com.lhs.service.BoardService;
import com.lhs.util.FileUtil;

@Service
public class BoardServiceImpl implements BoardService{

	@Autowired BoardDao bDao;
	@Autowired AttFileDao attFileDao;
	@Autowired FileUtil fileUtil;
	
	
	@Override
	public ArrayList<HashMap<String, Object>> list(HashMap<String, String> params) {
		return bDao.list(params);
	}

	@Override
	public int getTotalArticleCnt(HashMap<String, String> params) {
		return bDao.getTotalArticleCnt(params);
	}

	@Override
	public int write(HashMap<String, Object> params, List<MultipartFile> mFiles) {
	
		//1. board DB에 글 정보등록 + hasFile 
		int write = bDao.write(params);
		
		System.out.println("result of params  :" + params);
		//useGeneratedKeys를 사용하면 나올때 params 에 자동 put되어 나옴.. cool! 
		
		//2. 첨부파일 존재시 board_attach DB에 첨부파일 정보등록 
		if(params.get("hasFile").equals("Y")) { // 첨부파일 존재시 
			for(MultipartFile mFile : mFiles) {// 갖고온파일리스트 해체 
				
				if(mFile.getSize()!=0) {//파일 레알로 존재하면 
					//DB 에 필요정보 추출 및 파람스에 담기. 
					params.put("fileName", mFile.getOriginalFilename()); //파일명 
					params.put("fileType", mFile.getContentType());// 확장자 
					params.put("fileSize", mFile.getSize());// 사이즈 
					
					//make Fake Name
					// UUID : 숫자+알파벳 38자 무작위 난수 만듦.
					String fakeName = UUID.randomUUID().toString().replace("-", "");
					
					params.put("fakeName", fakeName); // 가짜이름 
					
					//필요정보 파람스에 담은 후 ,board_attach DB insert 쿼리날림.(*없던 boardSeq도 담겼다.)  
					attFileDao.addAttFile(params);
					
					//3. DB에 정보 저장만했으니, 이제 실제파일을 지정해놓은 물리적 위치로 카피 .. 
					try {
						fileUtil.copyFile(mFile, fakeName);
					} catch (IOException e) {
						
						e.printStackTrace();
					}
				}
			}
		}

		return write;
	}

	//글 조회 
	@Override
	public HashMap<String, Object> read(HashMap<String, Object> params) {
		
		//조회할때마다 조회수 업뎃 
		// 조회할때마다 조회수 증가 
		bDao.updateHits(params);
		
		return bDao.read(params);
	}

	@Override
	public int update(HashMap<String, Object> params, List<MultipartFile> mFiles) {
		//2. 첨부파일 존재시 board_attach DB에 첨부파일 정보등록 
				//이때 첨부파일은 update 가 아닌 한번더 insert해주는것! 
				if(params.get("hasFile").equals("Y")) { // 첨부파일 존재시 
					
					for(MultipartFile mFile : mFiles) {
						if(mFile.getSize()!= 0) { // 파일존재하면 
							//DB 에 필요정보 추출 및 파람스에 담기. 
							params.put("fileName", mFile.getOriginalFilename()); //파일명 
							params.put("fileType", mFile.getContentType());// 확장자 
							params.put("fileSize", mFile.getSize());// 사이즈 
							
							//make Fake Name
							// UUID : 숫자+알파벳 38자 무작위 난수 만듦.
							String fakeName = UUID.randomUUID().toString().replace("-", "");
							
							params.put("fakeName", fakeName); // 가짜이름 
							
							
							// * 없던 boardSeq도 담아주고.. 
							//필요정보 파람스에 담은 후 ,board_attach DB insert 메서드 호출  
							attFileDao.addAttFile(params); // 첨부파일 존재시에만 첨부파일dao 
							System.out.println("are you there");
							//3. DB에 정보 저장만했으니, 이제 실제파일을 지정해놓은 물리적 위치로 카피 .. 
							try {
								fileUtil.copyFile(mFile, fakeName);
							} catch (IOException e) {
								
								e.printStackTrace();
							}
					
						}
					}
				}	
				// 글 수정 dao 
		return bDao.update(params);
	}

	@Override
	public int delete(HashMap<String, Object> params) {
		if(params.get("hasFile").equals("Y")) { // 첨부파일 있으면 
		
			//0. 삭제 전에 파일정보 받아놓는다(물리적 삭제 위해 ) 
			List<HashMap<String, Object>> fileInfos = attFileDao.readAttFiles(params);
			//1.  첨부파일 정보 db에서 삭제 	
			attFileDao.deleteAttFileByBoard(params); 
			//2. 글 삭제 
			int delete = bDao.delete(params);
			//3.물리적 삭제
			for(HashMap<String, Object> file :fileInfos) {
				fileUtil.deleteFile(file);
			}
			
			return delete;
		}
		return bDao.delete(params);
	}

	@Override
	public boolean deleteAttFile(HashMap<String, Object> params) {
		
		System.out.println("deleteAttFile params: " + params);
		// 트랜잭션 작업 위한 boolean값. 
		boolean result = false;
		
		//1.삭제 전, 해당글의 삭제할 첨부파일 정보부터 읽어온다. 
				// 물리적위치에서도 지워야하기때문에 정보필요.. 먼저 지워버리면 정보가 날아가버려서 물리적위치 탐색불가 . . 
				HashMap<String, Object> fileInfo = attFileDao.readAttFileByPk(Integer.parseInt(String.valueOf(params.get("fileIdx"))));
				System.out.println("fileInfo:" +fileInfo);
				//2. 해당 첨부파일 board_attach 에서 삭제 ! > 삭제 수행 성공하면(결과 1) result=true;
				result = (attFileDao.deleteAttFile(params) == 1) ; 
				
				//3. 원 게시글과 첨부파일 정보의 관계 확인 
				//					: 해당글의 모든 첨부파일 불러오기 (attFileDao.getAttFiles(params)) , 후 게시글의 has_file을 0으로.. 
				
				List<HashMap<String, Object>> attFiles = attFileDao.readAttFiles(params);
				System.out.println("attFiles check" + attFiles);
				
				//for(HashMap<String, Object> attFile : attFiles) {
					
				if(attFiles.size() == 0) { // List size 0 이면 즉, 모든 첨부파일이 1개도 존재하지 않으면.. 
						//해당 게시글의 has_file을 0으로 바꾸는 dao 호출. 
					System.out.println("params for update hasfile zero" + params);
						result = (result==true) && (bDao.updateHasFileToZero(params)== 1) ;
						// 이전 수행작업이 성공이면서 (result==true), 이번 수행도 성공(결과==1) 인 경우. --> true && true = true. --> result = true.. 
						
						//4. 마지막으로 물리디스크에서도 해당 파일 삭제.
						//  			맨처음,DB에서 불러와놓았던 fileInfo 정보보내서 해당 파일 삭제한다. 
						result = (result == fileUtil.deleteFile(fileInfo)) ; 
						
					}else {// 하나라도 존재하는경우 hasfile 건들지말고, 물리적 파일만 삭제해준다. 

						result = (result == fileUtil.deleteFile(fileInfo)) ; 
						// 이전 수행작업 결과가 true이고 deleteFile 결과도 true인 경우, true == true 이므로 최종 result값이 true로 반환됨. 
						// 즉 모든 작업이 성공해야만 작업이 완료됨. 하나라도 false가 되면 완료실패  > 트랜잭션. 
					
					}
				return result;
	}



}
