# MyNGTVApp
##  Desciption 
이 앱은 모바일 나이스게임 홈페이지가 없어서 괴로워 하는 나겜충들을 위해 만들어지다가 무기한 개발 중단된 앱의 소스 입니다.

## 현재 구현된 사항 
- 게시판 목록
- 게시물 목록
- 게시물 내용(일부)
- 글쓰기(일부)
- 로그인
- 화면에서 사용되는 각 HTTP POST 액션 (차후 설계 변경 예정, 변경중 일부 삭제됨, 복구 안됨 ㅠㅠ)

## 미구현 사항
- 댓글 등록
- 댓댓글 등록 
- 댓글, 댓댓글 삭제 
- 글 상세에서 댓글의 상태 구분(댓글인지, 댓댓글인지)
- 글 수정 
- 글 삭제 

## 확인된 오류 및 구현이 덜된 부분
- 게시물 상세화면
	- 댓글 부분이 한줄로 나오는 문제
	- 페이지 로딩시 웹뷰 크기의 변경 문제로 인해 AutoLayout부분에서 오류 발생
	- 간혹 큰 용량의 이미지를 로딩할 때 로딩이 끝나지 않았는데 webviewDidFinish부분이 호출되어 화면에 제대로 된 사이즈로 웹뷰가 리사이징 되지 않음
	- 그 외 기타 문제 많음 :(
- 글쓰기 부분의 글쓰는 부분의 구분이 되질 않음 
- 사진 업로드 부분 개선 필요
	- 여러장 올릴수 있도록 수정 
	- 사진 업로드시 해당 사진의 확인이 가능하도록 수정 필요 
	- 올린 사진을 삭제하거나 변경할 수 있어야 함
- 각 신규 게시판에 대한 대응이 안되있음 (실시간 리플채팅 등...)

이 소스는 누구나 가져다 사용하셔도 무방합니다.  쓸게 없습니다만...
