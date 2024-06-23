import streamlit as st
import requests
import json

# 设置页面标题
st.title("FitBot")

# 初始化会话状态
if "messages" not in st.session_state:
    st.session_state.messages = [{"role": "ai", "content": "Hello, please upload a video for analysis."}]
    st.session_state.first_interaction = True
    st.session_state.user_input = ""

# 显示聊天记录
st.header("Chat with Your Personal AI Fitness Trainer")

def display_message(role, content):
    if role == "ai":
        st.markdown(
            f'<div style="background-color:#e6f7ff; color:#000000; padding:10px; border-radius:10px; margin-bottom:10px;"><strong>AI:</strong><br>{content}</div>',
            unsafe_allow_html=True
        )
    else:
        st.markdown(
            f'<div style="background-color:#e6f7ff; color:#000000; padding:10px; border-radius:10px; margin-bottom:10px;"><strong>You:</strong><br>{content}</div>',
            unsafe_allow_html=True
        )

for i, msg in enumerate(st.session_state.messages):
    display_message(msg['role'], msg['content'])

def format_evaluation_result(result):
    formatted_text = "<h3 style='color:black;'>Overall Evaluation</h3>\n"
    
    # 检查并获取 overall_valuation
    overall_valuation = result.get("data", {}).get("overall_valuation", [])
    for index, evaluation in enumerate(overall_valuation, 1):
        formatted_text += f"<p style='color:black;'>{index}. {evaluation}</p>"
    
    formatted_text += "<h3 style='color:black;'>Potential Improvements</h3>\n"
    
    # 检查并获取 potential_improvement
    potential_improvements = result.get("data", {}).get("potential_improvement", [])
    for index, improvement in enumerate(potential_improvements, 1):
        formatted_text += f"<p style='color:black;'>{index}. <b>Problem</b>: {improvement.get('problem', 'N/A')}<br>"
        formatted_text += f"&nbsp;&nbsp;&nbsp;&nbsp;<b>Improvement</b>: {improvement.get('improvement', 'N/A')}</p>"

    return formatted_text

# 用户输入处理
if st.session_state.first_interaction:
    # 用户第一次对话：上传视频
    uploaded_video = st.file_uploader("Upload a video...", type=["mp4", "mov", "avi", "mkv"], key="video_uploader")
    if uploaded_video is not None:
        if st.button("Send Video", key="send_video_button"):
            try:
                # 将视频文件上传到后端
                files = {"file": uploaded_video}
                response = requests.post("http://10.56.64.33:5656/api/upload", files=files, timeout=30)
                response.raise_for_status()
                st.success("Video uploaded successfully!")
                st.session_state.messages.append({"role": "user", "content": "Uploaded a video."})
                
                # 解析 JSON 响应并获取文件路径
                response_data = response.json()
                file_path = response_data["data"]["file_path"]
                
                # 调用评估 API
                evaluate_addr = {"url": file_path}
                evaluate_response = requests.post("http://10.56.64.33:5656/api/evaluate", json=evaluate_addr, timeout=30)
                evaluate_response.raise_for_status()
                
                evaluation_result = evaluate_response.json()
                formatted_result = format_evaluation_result(evaluation_result)
                st.session_state.messages.append({"role": "ai", "content": formatted_result})
                
                st.session_state.first_interaction = False
                st.session_state.user_input = ""  # 清空输入框内容
                st.rerun()  # 触发页面刷新
                
            except requests.exceptions.Timeout:
                st.error("Request timed out. Please try again.")
            except requests.exceptions.RequestException as e:
                st.error(f"An error occurred: {e}")
# else:
#     # 后续对话：文本输入
#     user_input = st.text_area("You:", st.session_state.user_input, height=100, key="user_input_text_area")
#     if st.button("Send", key="send_text_button"):
#         if user_input:
#             # 更新会话状态
#             st.session_state.messages.append({"role": "user", "content": user_input})

#             try:
#                 # 发送用户输入到后端并获取 AI 回复
#                 response = requests.post("http://10.56.64.33:5656/api/chat", json={"message": user_input}, timeout=30)
#                 response.raise_for_status()
#                 ai_response = response.json().get("response")
                
#                 # 更新会话状态
#                 st.session_state.messages.append({"role": "ai", "content": ai_response})

#                 # 清空输入框
#                 st.session_state.user_input = ""
#                 st.rerun()
                
#             except requests.exceptions.Timeout:
#                 st.error("Request timed out. Please try again.")
#             except requests.exceptions.RequestException as e:
#                 st.error(f"An error occurred: {e}")
