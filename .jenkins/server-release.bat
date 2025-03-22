setlocal
cd %~dp0
call load-env
start "Release Server" docker compose --file docker-compose-release.yml up --build
endlocal