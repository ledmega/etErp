# 06. API 설계 가이드

## 1. REST API 설계 원칙

- **URL은 리소스 명사** 사용 (동사 금지)
- HTTP 메서드로 행위 표현
- 일관된 **응답 포맷** 사용
- HTTP 상태코드 적절히 사용
- 버전 관리: `/api/v1/...`

---

## 2. URL 네이밍 규칙

| 행위 | Method | URL 예시 |
|------|--------|----------|
| 목록 조회 | GET | `/api/v1/hr/employees` |
| 단건 조회 | GET | `/api/v1/hr/employees/{id}` |
| 등록 | POST | `/api/v1/hr/employees` |
| 수정 | PUT | `/api/v1/hr/employees/{id}` |
| 부분 수정 | PATCH | `/api/v1/hr/employees/{id}` |
| 삭제 | DELETE | `/api/v1/hr/employees/{id}` |

---

## 3. 공통 응답 포맷

### 성공 응답
```json
{
  "success": true,
  "code": "200",
  "message": "성공",
  "data": { ... }
}
```

### 목록 응답 (페이징)
```json
{
  "success": true,
  "code": "200",
  "message": "성공",
  "data": {
    "content": [ ... ],
    "page": 0,
    "size": 20,
    "totalElements": 100,
    "totalPages": 5,
    "last": false
  }
}
```

### 실패 응답
```json
{
  "success": false,
  "code": "E001",
  "message": "요청한 리소스를 찾을 수 없습니다.",
  "data": null
}
```

---

## 4. 공통 응답 코드

| 코드 | 의미 | HTTP Status |
|------|------|-------------|
| `200` | 성공 | 200 |
| `E001` | 리소스 없음 | 404 |
| `E002` | 입력값 오류 | 400 |
| `E003` | 인증 실패 | 401 |
| `E004` | 권한 없음 | 403 |
| `E005` | 중복 데이터 | 409 |
| `E999` | 서버 오류 | 500 |

---

## 5. 주요 API 목록

### 인증 (Auth)

| Method | URL | 설명 |
|--------|-----|------|
| POST | `/api/v1/auth/signup` | 가입 승인 요청 (승인 대기 상태로 계정 생성) |
| POST | `/api/v1/auth/login` | 로그인 (토큰 발급) |
| POST | `/api/v1/auth/logout` | 로그아웃 |
| POST | `/api/v1/auth/refresh` | 토큰 갱신 |
| GET  | `/api/v1/auth/me` | 내 정보 조회 |

**로그인 요청 예시:**
```json
POST /api/v1/auth/login
{
  "loginId": "admin",
  "password": "password123!"
}
```

**로그인 응답 예시:**
```json
{
  "success": true,
  "code": "200",
  "message": "로그인 성공",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9...",
    "tokenType": "Bearer",
    "expiresIn": 3600,
    "userInfo": {
      "userId": 1,
      "loginId": "admin",
      "userName": "관리자",
      "roles": ["ROLE_ADMIN"]
    }
  }
}
```

---

### 사용자 관리 (System)

| Method | URL | 설명 | 권한 |
|--------|-----|------|------|
| GET | `/api/v1/system/users` | 사용자 목록 | ADMIN |
| GET | `/api/v1/system/users/{id}` | 사용자 상세 | ADMIN |
| POST | `/api/v1/system/users` | 사용자 등록 | ADMIN |
| PUT | `/api/v1/system/users/{id}` | 사용자 수정 | ADMIN |
| DELETE | `/api/v1/system/users/{id}` | 사용자 삭제 | ADMIN |
| PATCH | `/api/v1/system/users/{id}/password` | 비밀번호 초기화 | ADMIN |

---

### 직원 관리 (HR)

| Method | URL | 설명 | 권한 |
|--------|-----|------|------|
| GET | `/api/v1/hr/employees` | 직원 목록 (검색/페이징) | HR, ADMIN |
| GET | `/api/v1/hr/employees/{id}` | 직원 상세 | HR, ADMIN |
| POST | `/api/v1/hr/employees` | 직원 등록 | HR |
| PUT | `/api/v1/hr/employees/{id}` | 직원 수정 | HR |
| DELETE | `/api/v1/hr/employees/{id}` | 직원 삭제 (논리) | HR |
| GET | `/api/v1/hr/departments` | 부서 목록 | ALL |
| POST | `/api/v1/hr/departments` | 부서 등록 | HR |

**직원 목록 쿼리 파라미터:**
```
GET /api/v1/hr/employees?deptId=1&status=A&keyword=홍길동&page=0&size=20&sort=empName,asc
```

---

### 근태 관리

| Method | URL | 설명 |
|--------|-----|------|
| GET | `/api/v1/hr/attendance` | 근태 목록 |
| POST | `/api/v1/hr/attendance/check-in` | 출근 처리 |
| POST | `/api/v1/hr/attendance/check-out` | 퇴근 처리 |
| GET | `/api/v1/hr/leaves` | 휴가 목록 |
| POST | `/api/v1/hr/leaves` | 휴가 신청 |
| PATCH | `/api/v1/hr/leaves/{id}/approve` | 휴가 승인 |
| PATCH | `/api/v1/hr/leaves/{id}/reject` | 휴가 반려 |

---

### 회계 (Accounting)

| Method | URL | 설명 |
|--------|-----|------|
| GET | `/api/v1/accounting/vouchers` | 전표 목록 |
| POST | `/api/v1/accounting/vouchers` | 전표 입력 |
| GET | `/api/v1/accounting/vouchers/{id}` | 전표 상세 |
| PATCH | `/api/v1/accounting/vouchers/{id}/approve` | 전표 승인 |
| DELETE | `/api/v1/accounting/vouchers/{id}` | 전표 취소 |
| GET | `/api/v1/accounting/accounts` | 계정과목 목록 |

---

## 6. API 요청 헤더

```http
Authorization: Bearer {accessToken}
Content-Type: application/json
Accept: application/json
```

---

## 7. 페이징 파라미터 (공통)

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `page` | `0` | 페이지 번호 (0부터 시작) |
| `size` | `20` | 페이지당 건수 |
| `sort` | `createdAt,desc` | 정렬 (컬럼,방향) |

---

## 8. Swagger UI 접속

개발 환경에서 API 문서는 아래 URL에서 확인 가능합니다.

```
http://localhost:8080/swagger-ui/index.html
http://localhost:8080/v3/api-docs
```

---
> 작성일: 2026-03-30 | 작성자: 개발팀
