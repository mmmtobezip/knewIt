from enum import StrEnum


class ErrorCode(StrEnum):
    AUTH_001 = "E_AUTH_001"
    AUTH_002 = "E_AUTH_002"
    PERM_001 = "E_PERM_001"
    VALD_001 = "E_VALD_001"
    VALD_002 = "E_VALD_002"
    DATA_001 = "E_DATA_001"
    DATA_002 = "E_DATA_002"
    LLM_001 = "E_LLM_001"
    LLM_002 = "E_LLM_002"
    LLM_003 = "E_LLM_003"
    NEWS_001 = "E_NEWS_001"
    CACH_001 = "E_CACH_001"
    SYS_001 = "E_SYS_001"
    SYS_002 = "E_SYS_002"


ERROR_HTTP_STATUS: dict[ErrorCode, int] = {
    ErrorCode.AUTH_001: 401,
    ErrorCode.AUTH_002: 401,
    ErrorCode.PERM_001: 403,
    ErrorCode.VALD_001: 400,
    ErrorCode.VALD_002: 400,
    ErrorCode.DATA_001: 404,
    ErrorCode.DATA_002: 204,
    ErrorCode.LLM_001: 502,
    ErrorCode.LLM_002: 408,
    ErrorCode.LLM_003: 429,
    ErrorCode.NEWS_001: 502,
    ErrorCode.CACH_001: 429,
    ErrorCode.SYS_001: 500,
    ErrorCode.SYS_002: 503,
}

ERROR_MESSAGES_KO: dict[ErrorCode, str] = {
    ErrorCode.AUTH_001: "세션이 만료되었습니다.",
    ErrorCode.AUTH_002: "인증에 실패했습니다.",
    ErrorCode.PERM_001: "해당 고객사를 조회할 권한이 없습니다.",
    ErrorCode.VALD_001: "메시지를 입력해주세요.",
    ErrorCode.VALD_002: "최대 500자까지 입력 가능합니다.",
    ErrorCode.DATA_001: "요청하신 데이터를 찾을 수 없습니다.",
    ErrorCode.DATA_002: "오늘은 주요 변동이 없습니다.",
    ErrorCode.LLM_001: "분석 데이터를 불러오지 못했습니다.",
    ErrorCode.LLM_002: "응답 시간이 초과되었습니다.",
    ErrorCode.LLM_003: "일시적으로 요청이 많습니다. 잠시 후 다시 시도해주세요.",
    ErrorCode.NEWS_001: "출처 데이터를 일시적으로 가져올 수 없습니다.",
    ErrorCode.CACH_001: "이미 갱신 중입니다.",
    ErrorCode.SYS_001: "요청 처리 중 오류가 발생했습니다.",
    ErrorCode.SYS_002: "서비스 점검 중입니다.",
}


class ApiException(Exception):
    def __init__(self, code: ErrorCode, detail: str | None = None) -> None:
        self.code = code
        self.detail = detail
        super().__init__(ERROR_MESSAGES_KO[code])

    @property
    def http_status(self) -> int:
        return ERROR_HTTP_STATUS[self.code]

    @property
    def message(self) -> str:
        return ERROR_MESSAGES_KO[self.code]
