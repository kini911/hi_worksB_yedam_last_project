package com.worksb.hi.board.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.type.BlobByteObjectArrayTypeHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.worksb.hi.board.service.BoardRequestVO;
import com.worksb.hi.board.service.BoardService;
import com.worksb.hi.board.service.BoardVO;
import com.worksb.hi.board.service.ScheVO;
import com.worksb.hi.board.service.TaskVO;
import com.worksb.hi.board.service.VoteVO;
import com.worksb.hi.member.service.MemberVO;

// 이진 0818 게시판관리 - 게시글,업무,일정,투표 등록

@Controller
public class BoardController {
	//이진	
	@Autowired
	BoardService boardService;
	
	// 이진
	// 게시글 등록 폼
    @GetMapping("/boardInsert")
	public String BoardInsertForm(@RequestParam int projectId, HttpSession session, Model model) {
		model.addAttribute("projectId", projectId);
		return "project/boardInsert";
	}
    
    // 업무글 등록
    @PostMapping("taskInsert")
    @ResponseBody
    public String taskInsert(@RequestBody BoardRequestVO brVO) {
    	//게시글
    	BoardVO boardVO = brVO.getBoardVO();
    	boardService.insertBoard(brVO.getBoardVO());
    	//상위업무
    	TaskVO taskVO = brVO.getTaskVO();
    	taskVO.setPrjBoardId(boardVO.getPrjBoardId());
    	boardService.insertTask(taskVO);
    	
    	//업무 담당
    	List<TaskVO> managerList = brVO.getPrjManager();
    	if(managerList != null) {
    		for(int i=0; i < managerList.size(); i++) {
    			TaskVO taskManager = managerList.get(i);
    			
    			taskManager.setPrjBoardId(taskVO.getPrjBoardId());
    			boardService.insertTaskManager(taskManager);

    		}
    	}
    	
    	
    	
    	//하위업무
    	List<TaskVO> taskList = brVO.getSubTask();
    	if(taskList != null){
    		TaskVO subtaskVO ;
	    	for(int i=0; i < taskList.size(); i++) {
	    		BoardVO subBoardVO = new BoardVO();
	    		subtaskVO = taskList.get(i);
	    		
	    		// 하위 업무 - 게시글 테이블 저장
	    		subBoardVO.setPrjBoardTitle(subtaskVO.getPrjBoardTitle());
	    		subBoardVO.setMemberId(boardVO.getMemberId());
	    		subBoardVO.setProjectId(boardVO.getProjectId());
	    		subBoardVO.setBoardType(boardVO.getBoardType());
	    		subBoardVO.setInspYn("E2");
	    		boardService.insertBoard(subBoardVO);
	    		
	    		// 하위 업무 - 업무 테이블 저장
	    		subtaskVO.setPrjBoardId(subBoardVO.getPrjBoardId());
	    		subtaskVO.setHighTaskId(taskVO.getTaskId());
	    		subtaskVO.setState(taskVO.getState());
	    		boardService.insertTask(subtaskVO);
	    	}
    	}
    	return "redirect:/projectFeed?projectId=" + boardVO.getProjectId();
    }
    
	//게시글 등록 - 게시글, 일정, 투표
	@PostMapping("/boardInsert")
	public String boardInsertProcess(BoardVO boardVO, TaskVO taskVO, VoteVO voteVO, ScheVO scheVO, HttpSession session) {
		
		MemberVO member = (MemberVO)session.getAttribute("memberInfo");
		String memberId = member.getMemberId();
		
        boardVO.setMemberId(memberId);
		
        String boardType = boardVO.getBoardType();
        
        // 글 prj_project
		boardService.insertBoard(boardVO);
        
		int prjBoardId = boardVO.getPrjBoardId();
		
        if(boardType.equals("C6")) {
        	// 일정
        	scheVO.setPrjBoardId(prjBoardId);
        	
        	boardService.insertSche(scheVO);
        	
        }else if(boardType.equals("C7")) {
        	// 투표
        	voteVO.setPrjBoardId(prjBoardId);
        	
        	voteVO.setAnonyVote(voteVO.getAnonyVote() == null ? "A2" : voteVO.getAnonyVote());
        	voteVO.setCompnoVote(voteVO.getCompnoVote() == null ? "A2" : voteVO.getCompnoVote());
        	voteVO.setResultYn(voteVO.getResultYn() == null ? "A2" : voteVO.getResultYn());
        	
        	// 투표글 등록
        	boardService.insertVote(voteVO);
   
        }
        
		return "redirect:/projectFeed?projectId=" + boardVO.getProjectId();
	}
	
	
	// 일정 조회
	@GetMapping("getScheInfo")
	@ResponseBody
	public ScheVO getScheInfo(ScheVO scheVO) {
		return boardService.getScheInfo(scheVO);
	}
	
	// 투표 조회
	@GetMapping("getVoteInfo")
	@ResponseBody
	public Map<String, List<VoteVO>> getVoteInfo(@RequestParam("prjBoardId") int prjBoardId) {
		
        Map<String, List<VoteVO>> resultMap = new HashMap<>();
        
        VoteVO voteVO = new VoteVO();
        voteVO.setPrjBoardId(prjBoardId);
        
        // 투표글
        List<VoteVO> voteInfo = boardService.getVoteInfo(voteVO);
        // 투표 항목
        List<VoteVO> voteList = boardService.getVoteList(voteVO);
        
        resultMap.put("voteInfo", voteInfo);
        resultMap.put("voteList", voteList);
        		
        return resultMap;
	}

	// 업무 조회
	@GetMapping("getTaskInfo")
	@ResponseBody
	public Map<String, List<TaskVO>> getTaskInfo(@RequestParam("prjBoardId") int prjBoardId) {
	    Map<String, List<TaskVO>> resultMap = new HashMap<>();
	    
	    TaskVO taskVO = new TaskVO();
	    taskVO.setPrjBoardId(prjBoardId);
	    
	    // 상위 업무
	    List<TaskVO> highTask = boardService.getHighTask(taskVO);
	    
	    int taskId = boardService.getHighTaskId(taskVO);
	    // 하위 업무
	    List<TaskVO> subTask = boardService.getSubTask(taskId);
	    
	    resultMap.put("highTask", highTask);
	    resultMap.put("subTask", subTask);

	    return resultMap;
	}


	
	
	
	
	
	
	
}
