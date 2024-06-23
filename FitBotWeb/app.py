import streamlit as st
import requests

# Set page title
st.title("AI Chat and Video Upload")

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = [{"role": "ai", "content": "Hello, please upload a video for analysis."}]
    st.session_state.first_interaction = True
    st.session_state.user_input = ""

# Display chat history
st.header("Chat with AI")

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

for i, msg in enumerate(st.session_state.messages):
    display_message(msg['role'], msg['content'])

# Handle user input
if st.session_state.first_interaction:
    # First interaction: Upload video
    uploaded_video = st.file_uploader("Upload a video...", type=["mp4", "mov", "avi", "mkv"], key="video_uploader")
    if uploaded_video is not None:
        if st.button("Send Video", key="send_video_button"):
            # Send video file to backend
            # files = {"file": uploaded_video}
            # response = requests.post("http://localhost:8000/upload", files=files)
            # if response.status_code == 200:
            #     st.success("Video uploaded successfully!")
            #     st.session_state.messages.append({"role": "user", "content": "Uploaded a video."})
            #     # Add AI response for video processing
            #     st.session_state.messages.append({"role": "ai", "content": "Video received and processed."})
            #     st.session_state.first_interaction = False
            #     st.session_state.user_input = ""  # Clear input box content
            #     st.rerun()  # Trigger page refresh
            # else:
            #     st.error("Failed to upload video.")
            st.rerun()
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
