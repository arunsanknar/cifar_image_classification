# Image Classification on CIFAR-10

This example shows you how to build `train`, `test` and `infer` processes
for image classification problems. In particular, it will show you the format
of the return of `test` and `infer`. For an object detection problem, those
returns can be a little bit involved. But to get most out of Alectio's platform,
those returns needs to be correct. 

All of the following steps assume that your terminal points to the current directory, i.e. `./cifar_image_classification`

### 1. Set up a virtual environment (optional) and install Alectio SDK
Before getting started, please make sure you completed the [initial installation instructions](https://www.notion.so/AlectioSDK-c8fd44a44249497f95a25fac282c2d87) to set-up your environment. 

To recap, the steps were setting up a virtual environment and then installing the AlectioSDK in that environment. 

To install the AlectioSDK from within the current directory (`./examples/object_detection`) run:

```bash
pip install alectio-sdk
```

### 2. Runing the experiment
In this folder edit "token=" in [main.py](./main.py) with the one you received from frontend

This should look something like this

```python
import argparse
import yaml, json
from alectio_sdk.sdk import Pipeline
from processes import train, test, infer, getdatasetstate

with open("./config.yaml", "r") as stream:
    args = yaml.safe_load(stream)

# put the train/test/infer processes into the constructor
AlectioPipeline  = Pipeline(
                            name=args["exp_name"],
                            train_fn=train,
                            test_fn=test,
                            infer_fn=infer,
                            getstate_fn=getdatasetstate,
                            args=args,
                            token='<YOUR_TOKEN_HERE>'
)

if __name__ == "__main__":
	AlectioPipeline()
```
Replace **<YOUR_TOKEN_HERE>** with the one you just received from frontend.

Then run:
```bash
python main.py
```

## Implementation Documentation

### 1. Build Train Process
We will train a [Basic CNN based on the official PyTorch tutorial] (https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html) for
this demo. The model is defined in `model.py`. Feel free to change it as you please. 

To try out this step, run:

```
python model.py
```

### 2. Build Test Process
The test process tests the model trained in each active learning loop.
In this example, the test process is the `test` function defined 
in `processes.py`. 

```
python processes.py
```

#### Return of the Test Process 
You will need to run non-maximum suppression on the predictions on the test images and return 
the final detections along with the ground-truth bounding boxes and objects
on each image. 

The return of the `test` function is a dictionary 
```
{"predictions": predictions, "labels": labels}
```

Both `predictions` and `labels` are lists where `labels` denotes the ground truths for the images.

### 3. Build Infer Process
The infer process is used to apply the model to the unlabeled set to run inference. 
We will use the inferred output to estimate which of those unlabeled data will
be most valuable to your model.

Refer to main [AlectioSDK ReadMe](../../README.md) for general information regarding the 
arguments of this process.

#### Return of the Infer Process
The return of the infer process is a dictionary
```python
{"outputs": outputs}
```

`outputs` is a dictionary whose keys are the indices of the unlabeled
images. The value of `outputs[i]` is a dictionary that records the output of
the model on training image `i`. 

## TODO
- [x] Implementation of additional metrics including:
  - [x] queried per class
  - [x] confusion matrix
  - [x] label disagreement
  - [x] accuracy per class

- [x] Output should include score distribution and logits 
