## API
1. upload video

`POST /api/upload`

request:
```json
{
  "file": file
}
```
response:
```json
{
    "data": {
        "file_path": "[Video_path]"
    },
    "statusCode": 0,
    "statusMessage": "Success"
}
```
2. evaluate

`POST /api/evaluate`

request:
```json
{
  "url": "VcWkx1719100662IMG_3723.MOV"
}
```
response:
```json
{
    "data": {
        "overall_evaluation": [
            "The individual is attempting a deadlift, which is a fundamental strength training exercise",
            "The posture shows some good elements, such as a relatively straight back",
            "However, there are several areas that need improvement for safety and effectiveness"
        ],
        "potential_improvement": [
            {
                "improvement": "Widen the stance to about shoulder-width apart for better stability and power generation",
                "problem": "Stance appears too narrow"
            },
            {
                "improvement": "Ensure a firm overhand or mixed grip on the barbell, with hands just outside the legs",
                "problem": "Grip on the barbell is not visible"
            },
            {
                "improvement": "Lower the hips slightly to engage the legs more, creating a more powerful initial drive",
                "problem": "Hips seem to be too high"
            },
            {
                "improvement": "Adjust position so that shoulders are directly over or slightly behind the bar at the starting position",
                "problem": "Shoulders appear to be in front of the bar"
            },
            {
                "improvement": "Maintain a neutral neck position by looking at a spot on the floor about 6-8 feet in front, keeping the chin slightly tucked",
                "problem": "Head position is not in a neutral spine alignment"
            },
            {
                "improvement": "Emphasize bracing the core throughout the entire movement for spinal stability and power transfer",
                "problem": "Core engagement is unclear"
            }
        ]
    },
    "statusCode": 0,
    "statusMessage": "Success"
}
```