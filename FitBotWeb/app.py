import streamlit as st
import requests
import json

# Set page title
st.title("FitBot")

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = [{"role": "ai", "content": "Hello, please upload a video for analysis."}]
    st.session_state.first_interaction = True
    st.session_state.user_input = ""

# Display chat history
st.header("Chat with Your Personal AI Fitness Trainer")

def display_message(role, content):
    if role == "ai":
        st.markdown(
            f'<div style="background-color:#e6f7ff; color:#000000; padding:10px; border-radius:10px; margin-bottom:10px;"><strong>AI:</strong> {content}</div>',
            unsafe_allow_html=True
        )
    else:
        st.markdown(
            f'<div style="background-color:#e6f7ff; color:#000000; padding:10px; border-radius:10px; margin-bottom:10px;"><strong>You:</strong> {content}</div>',
            unsafe_allow_html=True
        )

def json_to_text(data):
        text = ""

        # 添加总体评估
        text += "### Overall Evaluation\n"
        for index, evaluation in enumerate(data['data']['overall_evaluation'], 1):
            text += f"{index}. {evaluation}\n"

        # 添加改进建议
        text += "\n### Potential Improvements\n"
        for index, improvement in enumerate(data['data']['potential_improvement'], 1):
            text += f"{index}. **Problem**: {improvement['problem']}\n"
            text += f"   - **Improvement**: {improvement['improvement']}\n"

        # 添加状态信息
        text += "\n### Status\n"
        text += f"- **StatusCode**: {data['statusCode']}\n"
        text += f"- **StatusMessage**: {data['statusMessage']}\n"

        return text

for i, msg in enumerate(st.session_state.messages):
    display_message(msg['role'], msg['content'])

# Handle user input
if st.session_state.first_interaction:
    # First interaction: Upload video
    uploaded_video = st.file_uploader("Upload a video...", type=["mp4", "mov", "avi", "mkv"], key="video_uploader")
    if uploaded_video is not None:
        if st.button("Send Video", key="send_video_button"):
            #Send video file to backend
            files = {"file": uploaded_video}
            response = requests.post("http://10.56.64.33:5656/api/upload", files=files)
            if response.status_code == 200:
                st.success("Video uploaded successfully!")
                st.session_state.messages.append({"role": "user", "content": "Uploaded a video."})
                #json and get the filepath
                response_data = response.json()
                file_path = response_data["data"]["file_path"]
                # Call the evaluation API
                evaluate_addr = {"url": file_path}
                evaluate = requests.post("http://10.56.64.33:5656/api/evaluate", url=evaluate_addr)
                if evaluate.status_code == 200:
                    st.session_state.messages.append({"role": "ai", "content": "Video received and processed."})
                    st.session_state.first_interaction = False
                    st.session_state.user_input = ""  # Clear input box content
                    data = json.loads(evaluate.data)
                    result_text = json_to_text(data)
                    st.session_state.messages.append({"role": "ai", "content": result_text})
                    st.rerun()  # Trigger page refresh
                else:
                    st.error("Failed to evaluate the video.")
            else:
                st.error("Failed to upload video.")
else:
    # Subsequent interactions: Text input
    user_input = st.text_area("You:", st.session_state.user_input, height=100, key="user_input_text_area")
    if st.button("Send", key="send_text_button"):
        if user_input:
            # Update chat history
            st.session_state.messages.append({"role": "user", "content": user_input})

            # # Send user input to backend and get AI response
            # response = requests.post("http://localhost:8000/chat", json={"message": user_input})
            # ai_response = response.json().get("response")

            # # Update chat history with AI response
            # st.session_state.messages.append({"role": "ai", "content": ai_response})

            # Clear input box
            st.session_state.user_input = ""
            st.rerun()

