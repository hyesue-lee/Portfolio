package com.lhs.service;

import java.util.HashMap;
import java.util.List;

public interface AttFileService {
	
	/** type, board_seq 통한 해당 게시글의 모든 첨부파일 불러오기. 
	 * @param params
	 * @return
	 */
	public List<HashMap<String, Object>> readAttFiles(HashMap<String, Object> params);
	
	/**
	 *	pk를 통해 해당 첨부파일 불러오기.
	 * @param fileIdx
	 * @return
	 */
	public HashMap<String, Object> readAttFileByPk(int fileIdx);
	

		



	

}
