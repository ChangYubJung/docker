FROM node:alpine as builder 
#as builder 는 다음 FROM 전 까지는 모두 builder stage 명시.
#빌드파일들을 생성하는 것이 목표. /usr/src/app/build로 들어간다.

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install

COPY ./ ./

#CMD ["npm", "run", "build"]
RUN npm run build
#여기까지는 build file을 만드는 과정. Builder Stag

#이 밑으로는 Nginx시작 -> 브라우저 요청에 따라 제공!  Run Stage

FROM nginx
#nginx 베이스 이미지
EXPOSE 80
#nginx default port -> 80   EXPOSE -> 포트맵핑.
COPY --from=builder /usr/src/app/build /usr/share/nginx/html 
# --from=[이름] -> 다른 stage에 있는 file 복사할때 stage 명시
#/usr/src/app/build 에 있는 파일 /usr/share/nginx/html 에 복사
#/usr/share/nginx/html은 nginx default 디렉토리. 아무 디렉토리에 복사하면 안됨, 설정을 통해서 변경은 가능.