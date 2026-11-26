defmodule FeatureParameterTypes do
  use ExBdd.ParameterTypes

  parameter_type(:iata_route,
    regexp: ~r/([A-Z]{3})-([A-Z]{3})/,
    transform: fn from, to -> %{from: from, to: to} end
  )

  parameter_type(:priority, regexp: ~r/low|normal|high/)

  parameter_type(:seat,
    regexp: ~r/[0-9]+[A-F]/,
    transform: fn seat -> %{seat: seat} end
  )
end
