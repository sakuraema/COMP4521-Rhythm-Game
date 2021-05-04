using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scroller : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        transform.position = new Vector3 (0.0f, 0.0f, 300.0f * (BPM / 60.0f) * (50.0f / 60.0f));
    }

    // Update is called once per frame
    void Update()
    {
        transform.position -= new Vector3(0.0f, 0.0f, BPM * Time.deltaTime * (50.0f / 60.0f));
    }

    public int BPM;
}
