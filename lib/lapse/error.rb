module Lapse
  # Standard Lapse error
  class Error < StandardError; end

  # Raised when Lapse returns a 400 HTTP status code
  class BadRequest < Error; end

  # Raised when Lapse returns a 401 HTTP status code
  class Unauthorized < Error; end

  # Raised when Lapse returns a 403 HTTP status code
  class Forbidden < Error; end

  # Raised when Lapse returns a 404 HTTP status code
  class NotFound < Error; end

  # Raised when Lapse returns a 406 HTTP status code
  class NotAcceptable < Error; end

  # Raised when Lapse returns a 422 HTTP status code
  class UnprocessableEntity < Error; end

  # Raised when Lapse returns a 500 HTTP status code
  class InternalServerError < Error; end

  # Raised when Lapse returns a 501 HTTP status code
  class NotImplemented < Error; end

  # Raised when Lapse returns a 502 HTTP status code
  class BadGateway < Error; end

  # Raised when Lapse returns a 503 HTTP status code
  class ServiceUnavailable < Error; end

  # Raised when a unique ID is required but not provided
  class UniqueIDRequired < Error; end

  # Status code to exception map
  ERROR_MAP = {
    400 => Lapse::BadRequest,
    401 => Lapse::Unauthorized,
    403 => Lapse::Forbidden,
    404 => Lapse::NotFound,
    406 => Lapse::NotAcceptable,
    422 => Lapse::UnprocessableEntity,
    500 => Lapse::InternalServerError,
    501 => Lapse::NotImplemented,
    502 => Lapse::BadGateway,
    503 => Lapse::ServiceUnavailable
  }
end
